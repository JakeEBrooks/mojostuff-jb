from datetime.datetime import datetime

struct logger:
    var start_datetime: datetime
    var loglevel: UInt8

    fn __init__(inout self, loglevel: UInt8 = 1):
        self.start_datetime = datetime()
        self.loglevel = loglevel
        let timestring = String(self.start_datetime.year) + "-"
                        + String(self.start_datetime.month) + "-"
                        + String(self.start_datetime.day) + " "
                        + String(self.start_datetime.hour) + ":"
                        + String(self.start_datetime.minute) + ":"
                        + String(self.start_datetime.second) + "."
                        + String(self.start_datetime.nanosecond)
        print("--- Logging starting at", timestring)

    fn debug(self, msg: String):
        if self.loglevel <= 0:
            let now = datetime()
            let timestring = String(now.year) + "-"
                            + String(now.month) + "-"
                            + String(now.day) + " "
                            + String(now.hour) + ":"
                            + String(now.minute) + ":"
                            + String(now.second) + "."
                            + String(now.nanosecond)
            print(timestring, "DEBUG |", msg)

    fn info(self, msg: String):
        if self.loglevel <= 1:
            let now = datetime()
            let timestring = String(now.year) + "-"
                            + String(now.month) + "-"
                            + String(now.day) + " "
                            + String(now.hour) + ":"
                            + String(now.minute) + ":"
                            + String(now.second) + "."
                            + String(now.nanosecond)
            print(timestring, "INFO |", msg)

    fn warning(self, msg: String):
        if self.loglevel <= 2:
            let now = datetime()
            let timestring = String(now.year) + "-"
                            + String(now.month) + "-"
                            + String(now.day) + " "
                            + String(now.hour) + ":"
                            + String(now.minute) + ":"
                            + String(now.second) + "."
                            + String(now.nanosecond)
            print(timestring, "WARNING |", msg)

    fn critical(self, msg: String):
        if self.loglevel <= 3:
            let now = datetime()
            let timestring = String(now.year) + "-"
                            + String(now.month) + "-"
                            + String(now.day) + " "
                            + String(now.hour) + ":"
                            + String(now.minute) + ":"
                            + String(now.second) + "."
                            + String(now.nanosecond)
            print(timestring, "CRITICAL |", msg)
    
    fn __del__(owned self):
        let now = datetime()
        let timestring = String(now.year) + "-"
                        + String(now.month) + "-"
                        + String(now.day) + " "
                        + String(now.hour) + ":"
                        + String(now.minute) + ":"
                        + String(now.second) + "."
                        + String(now.nanosecond)
        print("--- Logging finishing at", timestring)