bool checkInitialValues(jobs)
{
  for(var i = 0; i < jobs.length; i++){
    if(!(jobs[i]['p']! <= jobs[i]['d']! && jobs[i]['d']! <= jobs[i]['T']!))  //sprawdzamy czy wartosci poczatkowe sa ok
        {
      return false;
    }
  }
  return true;
}