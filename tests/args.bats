@test "invalid arguments provided" {
  run ../mdtester.sh --federation fake
  [ "$status" -eq 1 ]
  [ "$output" = "Usage: mdtester.sh --federation [test|prod]" ]
}

@test "no federation option" {
  run ../mdtester.sh --federation
  [ "$status" -eq 1 ]
  [ "$output" = "Usage: mdtester.sh --federation [test|prod]" ]
}

@test "too many arguments provided" {
  run ../mdtester.sh --federation https://fake.com --fakeinput
  [ "$status" -eq 1 ]
  [ "$output" = "Usage: mdtester.sh --federation [test|prod]" ]
}

@test "unknown argument provided" {
  run ../mdtester.sh --fakearg stuff
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Unknown argument '--fakearg'" ]
  [ "${lines[1]}" = "Usage: mdtester.sh --federation [test|prod]" ]
}
