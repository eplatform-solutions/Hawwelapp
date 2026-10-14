function isValidDateOrTimestamp(v) {
    if (!v) return true; // يسمح بالقيمة الفارغة
    const date = v instanceof Date ? v : new Date(v); // إذا كان رقمًا، حوله إلى Date
    return !isNaN(date.getTime());
}

module.exports = {
    isValidDateOrTimestamp
}