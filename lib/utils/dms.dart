import 'package:flutter/material.dart';

// Coś jest nie tak z tymi pętlami tamm...

List<Map<String, int>> dms(List<Map<String, int>> jobs){
  List<Map<String, int>> kolejnosc = [];
  int lcm = getLcm(jobs);
  bool go = true;
  for(var i = 0; i < jobs.length; i++){
    if(!(jobs[i]['p']! < jobs[i]['d']! && jobs[i]['d']! <= jobs[i]['T']!))  //sprawdzamy czy wartosci poczatkowe sa ok
      {
        return [];
      }
  }

  jobs.sort((a, b) {
    return a['d']!.compareTo(b['d']!);
  },); //sortujemy wedlug deadline'u

  for(var i = 0; i < lcm; i++)
    {
      print('i = $i a lcm = $lcm');
      if(i>0)
        {
          for(final job in jobs)
            {
              if((i%job['T']! ==0))
                {
                  job['status'] = 1;
                }
            }
        }

      for(final job in jobs)
        {
          if(job['d']! < ((i%job['d']!) + job['p']! - 1) && job['status'] == 1)
            {
              return []; //blad
            }

          if(job['status']==1) //(job['d']! >= (i%job['d']!)) &&
            {
              kolejnosc.add({
                'id': job['id']!,
                'start': i,
                'end': job['p']!,
                'T': 0,
              });
              job['status'] = 0;
              i = i + job['p']! -1;
              break;
            }
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