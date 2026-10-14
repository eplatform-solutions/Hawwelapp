const getDateFormated = (date) => {
    let orderedDateInDateFormat = new Date(date);
    const year = orderedDateInDateFormat.getFullYear();
    const month = orderedDateInDateFormat.getMonth() + 1;
    const day = orderedDateInDateFormat.getDate();
    orderedDateInDateFormat = `${year} / ${month} / ${day}`;
    return orderedDateInDateFormat;
}

const getDateTimeFormated = (date) => {
    let orderedDateInDateFormat = new Date(date);
    const year = orderedDateInDateFormat.getFullYear();
    const month = orderedDateInDateFormat.getMonth() + 1;
    const day = orderedDateInDateFormat.getDate();
    const hours = orderedDateInDateFormat.getHours();
    const minutes = orderedDateInDateFormat.getMinutes();
    const seconds = orderedDateInDateFormat.getSeconds();
    const milliseconds = orderedDateInDateFormat.getMilliseconds();
    const period = hours < 12 ? "AM" : "PM";
    orderedDateInDateFormat = `${year} / ${month} / ${day} ${hours}:${minutes}:${seconds}:${milliseconds} ${period}`;
    return orderedDateInDateFormat;
}

module.exports = {
    getDateFormated,
    getDateTimeFormated
}