#/usr/bin/env awk
{
  count[NR] = $1;
  sum += $1;
}
END {
  p50 = 0;
  p90 = 0;
  p99 = 0;
  if (NR % 2) {
    p50 = count[(NR + 1) / 2];
  } else {
    p50 = (count[(NR / 2)] + count[(NR / 2) + 1]) / 2.0;
  }
  p90 = count[int(NR*0.90-0.5)];
  p99 = count[int(NR*0.99-0.5)];
  avg =sum / NR;

  printf "%s\t%s\t%s\t%f\n", p50, p90, p99, avg

}
