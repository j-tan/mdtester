@test "no arguments provided" {
  run ../mdtester.sh
  [ "$status" -eq 1 ]
  [ "$output" = "Usage: mdtester.sh [--entityid ENTITYID]" ]
}