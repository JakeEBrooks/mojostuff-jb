from logging.ctime import CTimeSpec, get_clocktime

@value
struct datetime:
    var era: Int
    var year: Int
    var month: Int
    var day: Int

    var hour: Int
    var minute: Int
    var second: Int

    fn __init__(inout self):
        let timenow = get_clocktime()
        var serial_days = timenow.seconds//86400
        let day_remainder = timenow.seconds - serial_days*86400

        self.hour = day_remainder//3600
        self.minute = (day_remainder - self.hour*3600)//60
        self.second = (day_remainder - self.hour*3600 - self.minute*60)

        self.era = (serial_days + 719468) // 146097
        self.year = 0
        self.month = 0
        self.day = 0


    

    

