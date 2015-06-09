@test "too many arguments provided" {
  run ../mdtester.sh --entityid https://fake.com --fakeinput
  [ "$status" -eq 1 ]
  [ "$output" = "Usage: mdtester.sh [--entityid ENTITYID]" ]
}

@test "unknown argument provided" {
  run ../mdtester.sh --fakearg stuff
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Unknown argument '--fakearg'" ]
  [ "${lines[1]}" = "Usage: mdtester.sh [--entityid ENTITYID]" ]
}