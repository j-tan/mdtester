@test "too many arguments provided" {
  run ../mdtester.sh --entityid https://fake.com --fakeinput
  [ "$status" -eq 1 ]
  [ "$output" = "Usage: mdtester.sh [--entityid ENTITYID]" ]
}