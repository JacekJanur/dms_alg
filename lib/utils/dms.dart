import 'package:flutter/material.dart';

// Coś jest nie tak z tymi pętlami tamm...

List<Map<String, int>> dms(List<Map<String, int>> x){
  List<Map<String, int>> jobs = x.toList();
  List<Map<String, int>> kolejnosc = [];
  int lcm = getLcm(jobs);

  List<int> listP = [];
  for(final job in jobs)
  {
    int a = job['p']!;
    listP.add(a);
  }

  jobs.sort((a, b) {
    return a['d']!.compareTo(b['d']!);
  },); //sortujemy wedlug deadline'u


  for(var i = 0; i < lcm; i++)
    {
      print('i = $i a lcm = $lcm');
        {
          for(final job in jobs)
            {
              if((i%job['T']! ==0))
                {
                  job['status'] = 1;
                }
            }
        }
      bool bPauza = true;
      for(final job in jobs)
        {
          if(job['status']==1)
            {
              kolejnosc.add({
                'id': job['id']!,
                'start': i,
                'end': 1,
                'T': 0,
              });
              listP[job['id']!] = listP[job['id']!] - 1;
              if(listP[job['id']!] == 0) {
                job['status'] = 0;
                listP[job['id']!] = job['p']!;
              }
              bPauza = false;
              break;
            }
        }
      if(bPauza)
        {
          kolejnosc.add({
            'id': -1,
            'start': i,
            'end': 1,
            'T': 0,
          });
        }
    }

  return kolejnosc;
}

int getLcm(List<Map<String, int>> jobs){
  List<int> deadlines = [];
  for(final job in jobs)
    {
      deadlines.add(job['d']!);
    }
  int lcm = 1;
  for(final d in deadlines)
    {
      lcm = lcm*d;
    }
  return lcm;
}