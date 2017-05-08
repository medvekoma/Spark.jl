package org.apache.spark.api.julia

import java.io.{BufferedOutputStream, DataOutputStream}
import java.net.Socket
import java.text.SimpleDateFormat
import java.util.Calendar

import org.apache.spark.internal.Logging
import org.apache.spark.util.Utils
import org.apache.spark.{Partition, SparkEnv, TaskContext}

/**
 * The thread responsible for writing the data from the JuliaRDD's parent iterator to the
 * Julia process.
 */
class OutputThread(context: TaskContext, it: Iterator[Any], worker: Socket, command: Array[Byte], split: Partition)
    extends Thread(s"stdout writer for julia") with Logging {

  val BUFFER_SIZE = 65536

  val env = SparkEnv.get

  @volatile private var _exception: Exception = null

  /** Contains the exception thrown while writing the parent iterator to the Julia process. */
  def exception: Option[Exception] = Option(_exception)

  /** Terminates the writer thread, ignoring any exceptions that may occur due to cleanup. */
  def shutdownOnTaskCompletion() {
    assert(context.isCompleted)
    this.interrupt()
  }

  override def run(): Unit = Utils.logUncaughtExceptions {
    try {
      val stream = new BufferedOutputStream(worker.getOutputStream, BUFFER_SIZE)
      val dataOut = new DataOutputStream(stream)
      // partition index
      dataOut.writeInt(split.index)
      dataOut.flush()
      // serialized command:
      dataOut.writeInt(command.length)
      dataOut.write(command)
      dataOut.flush()
      // data values
      writeIteratorToStream(it, dataOut)
      dataOut.writeInt(SpecialLengths.END_OF_DATA_SECTION)
      dataOut.writeInt(SpecialLengths.END_OF_STREAM)
      dataOut.flush()
    } catch {
      case e: Exception if context.isCompleted || context.isInterrupted =>
        // FIXME: logDebug("Exception thrown after task completion (likely due to cleanup)", e)
        println("Exception thrown after task completion (likely due to cleanup)", e)
        if (!worker.isClosed) {
          Utils.tryLog(worker.shutdownOutput())
        }

      case e: Exception =>
        // We must avoid throwing exceptions here, because the thread uncaught exception handler
        // will kill the whole executor (see org.apache.spark.executor.Executor).
        _exception = e
        if (!worker.isClosed) {
          Utils.tryLog(worker.shutdownOutput())
        }
    } finally {
      // Release memory used by this thread for shuffles
      // env.shuffleMemoryManager.releaseMemoryForThisThread()

      //TODO backward compatibility issue
      //env.shuffleMemoryManager.releaseMemoryForThisTask()

      // Release memory used by this thread for unrolling blocks
      // env.blockManager.memoryStore.releaseUnrollMemoryForThisThread()

      //TODO backward compatibility issue
      //env.blockManager.memoryStore.releaseUnrollMemoryForThisTask()
    }
  }

  val dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")

  def logMessage(msg: String): Unit = {
    val now = Calendar.getInstance().getTime()
    val nowText = dateFormat.format(now)

    logInfo(s"$nowText - ASZU - $msg")
  }

  def writeIteratorToStream[T](iter: Iterator[T], dataOut: DataOutputStream) {
    def write(obj: Any): Unit = {
      JuliaRDD.writeValueToStream(obj, dataOut)
    }
    val start = System.currentTimeMillis()
    iter.foreach(write)
    val diff = System.currentTimeMillis() - start
    logMessage(s"writeIteratorToStream in $diff ms.")
  }

}