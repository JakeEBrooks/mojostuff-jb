"""
A full implementation of the date-time algorithms described at http://howardhinnant.github.io/date_algorithms.html.
Also includes a datetime object representing an instant in time as d/m/y : h/m/s.
"""

from .ctime import get_clocktime

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
        let clocktimenow = get_clocktime()
        let days_since_epoch = clocktimenow.seconds//86400
        let day_remainder = clocktimenow.seconds - days_since_epoch*86400

        self.hour = day_remainder//3600
        self.minute = (day_remainder - self.hour*3600)//60
        self.second = (day_remainder - self.hour*3600 - self.minute*60)

        let civil_time = civil_from_days(days_since_epoch)
        self.era = civil_time[3].__int__()
        self.year = civil_time[2].__int__()
        self.month = civil_time[1].__int__()
        self.day = civil_time[0].__int__()
    
    fn update(inout self):
        self.__init__()

fn days_from_civil(day: Int, month: Int, year: Int) -> Int:
    """
    Converts an input civil date (i.e. Gregorian d/m/y) to a serial date, representing 
    the total number of days since the epoch 1/1/1970. An implentation of the algorithm 
    described at http://howardhinnant.github.io/date_algorithms.html#days_from_civil.
    """

    let era: Int
    let year_of_era: Int
    let day_of_year: Int
    let day_of_era: Int

    # One era is 400 years long (always 146097 days), so we floor divide by 400 to get the current era
    era = year // 400

    # Instead of the year starting every 1st January, by shifting the start date to 1st March
    # the leap day Feb 29th is right at the end of the adjusted year. This means that the very last month
    # is either 28 or 29 days long which is useful
    if month <= 2:
        year_of_era = year - era*400 - 1
    else:
        year_of_era = year - era*400
    
    # A linear function mapping the input month/day to total days elapsed in the adjusted year (see reference)
    day_of_year = (153 * ((month + 9) % 12) + 2) // 5 + (day - 1)
    # Finally, calculate days into the era by adjusting for an extra leap day every 4 years
    # and one less day every 100 years
    day_of_era = year_of_era * 365 + year_of_era//4 - year_of_era//100 + day_of_year
    # return the total number of days since the 1/1/1970 epoch (which itself is 719468 days after 1/3/0000)
    return era * 146097 + day_of_era - 719468

fn civil_from_days(serial: Int) -> SIMD[DType.int16, 4]:
    """
    Converts an input serial days (specifically days since 1/1/1970) to a 
    gregorian calendar date d/m/y. An implentation of the algorithm described 
    at http://howardhinnant.github.io/date_algorithms.html#civil_from_days.
    """

    let z: Int = serial + 719468 # z is the input serial date shifted to be centered around 1/3/0000 instead
    let era: Int
    let day_of_era: Int
    let year_of_era: Int
    let years_c: Int
    let months_c: Int
    let days_c: Int

    let day: Int
    let month: Int
    let year: Int


    # Get the eras since 1/3/0000 (since one era is always 146097 days)
    era = z//146097

    # Now get the days into the current era
    day_of_era = z - era*146097

    # Now get the years into the current era
    # corrections need to be applied for 1 extra day every 1460 days (4 years), 1 less day every 36524 days (100 years)
    # and 1 extra day every era (400 years)
    year_of_era = (day_of_era - day_of_era//1460 + day_of_era//36524 - day_of_era//146096)//365

    # Years since 1/3/0000 is
    years_c = era*400 + year_of_era
    # days since 1/3/[year_c], correcting for 4,100 year changes
    days_c = day_of_era - (365*year_of_era + year_of_era//4 - year_of_era//100)

    # To go from day_c to equivalent months since 1/3/[year_c], take the inverse
    # of the equation in days_from_civil (again see reference)
    months_c = (5*days_c +2)//153

    # Now to get the corrected d/m/y with year starting 1st January
    day = days_c - (153*months_c+2)//5 + 1
    if months_c < 10:
        month = months_c + 3
    else:
        month = months_c - 9
    if month <= 2:
        year = years_c + 1
    else:
        year = years_c
    
    return SIMD[DType.int16, 4](day, month, year, era)
    
fn is_leap(year: Int) -> Bool:
    """Calculates if an input gregorian calendar year is a leap year."""
    return (year % 4 == 0) and ((year % 100 != 0) or (year % 400 == 0))

fn last_day_of_month(month: Int, leap: Bool = False) -> Int:
    """
    Returns the last day of the month for a given month, which is also the total
    days in that month. If the year is a leap year, set `leap = True`.
    """
    let days_per_month = VariadicList(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    if month == 2 and leap:
        return 29
    else:
        return days_per_month[month - 1]

fn last_day_of_month(month: Int, year: Int) -> Int:
    """
    Returns the last day of the month for a given month and year, which is also the total
    days in that month.
    """
    let days_per_month = VariadicList(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    if month == 2 and is_leap(year):
        return 29
    else:
        return days_per_month[month - 1]

fn weekday_from_days(serial: Int) -> Int:
    """
    Calculate the weekday from an input serial day centered around 1/1/1970. Returns
    an integer in the range 0-6 representing Monday-Sunday.
    """
    if serial >= 0:
        return (serial + 3) % 7
    else:
        return (serial + 5) % 7 + 5
