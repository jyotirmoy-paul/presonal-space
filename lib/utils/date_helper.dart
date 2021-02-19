extension DateTimeHelper on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }

  // todo: check the accuracy of this method
  bool isSameWeek() {
    final lastWeek = DateTime.now().subtract(Duration(days: 7));
    final now = DateTime.now();
    return this.isAfter(lastWeek) && this.isBefore(now);
  }

  bool isSameYear() {
    final now = DateTime.now();
    return this.year == now.year;
  }
}
