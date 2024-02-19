class BookReaderProgress {
  final int chapterIndex;
  final int chapterTotal;
  final int pageIndex;
  final int pageTotal;

  BookReaderProgress({
    required this.chapterIndex,
    required this.chapterTotal,
    required this.pageIndex,
    required this.pageTotal,
  });

  double get progress {
    if (chapterTotal == 0) {
      return 0;
    }
    double progressPerChapter = 1 / chapterTotal;
    double progressPerPage = 1 / pageTotal;
    final chapterProgress = chapterIndex * progressPerChapter;
    final pageProgress = pageIndex * progressPerPage;
    return chapterProgress + pageProgress * progressPerChapter;
  }

  BookReaderProgress copyWith({
    int? chapterIndex,
    int? chapterTotal,
    int? pageIndex,
    int? pageTotal,
  }) {
    return BookReaderProgress(
      chapterIndex: chapterIndex ?? this.chapterIndex,
      chapterTotal: chapterTotal ?? this.chapterTotal,
      pageIndex: pageIndex ?? this.pageIndex,
      pageTotal: pageTotal ?? this.pageTotal,
    );
  }
}
