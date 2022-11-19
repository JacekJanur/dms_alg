import 'dart:math';

List<Map<String, int>> getJobs(n, max, min) {
  List<Map<String, int>> jobs = [];
  Random random = Random();
  int p = 0;
  int d = 0;
  int T = 0;

  for (int i = 0; i < n; i++) {
    int tmp = min<1 ? 1 : min;
    p = (random.nextInt(max + 1 - tmp) + tmp).toInt();
    d = p + random.nextInt(max + 3);
    T = (random.nextInt(2) + d).toInt();

    jobs.add({
      'id': i,
      'p': p,
      'd': d,
      'T': T,
    });
  }

  return jobs;
}