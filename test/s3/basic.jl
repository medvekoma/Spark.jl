lines = text_file(sc, "s3://fms.develop/app/scripts/bootstrap.sh")

collect(lines)
