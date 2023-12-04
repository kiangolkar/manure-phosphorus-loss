import rpy2.robjects as robjects
import io

class runRinpython:
    def runRFile(path_runoff , i):
        with io.open(path_runoff, "r", encoding="utf-8") as file:
            file_content = file.read()
            return file_content

        robjects.r.source(path_runoff, encoding="utf-8")