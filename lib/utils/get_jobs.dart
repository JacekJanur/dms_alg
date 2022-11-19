import 'dart:math';

List<Map<String, int>> getJobs(n, max, min) {
  List<Map<String, int>> jobs = [];
  Random random = new Random();
  int p = 0;
  int d = 0;
  int T = 0;

  for (int i = 0; i < n; i++) {
    p = (random.nextInt(max + 1 - min) + min).toInt();
    d = p + random.nextInt(max + 5);
    T = (random.nextInt(10) + d).toInt();

    jobs.add({
      'id': i,
      'p': p,
      'd': d,
      'T': T,
    });
  }

  return jobs;
}