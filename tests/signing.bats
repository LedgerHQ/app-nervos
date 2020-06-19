
. ./tests/lib.sh

@test "Signing APDU rejects when given garbage to sign and strict checking is enabled." {
  run apdu_fixed "8003c0000400001111"
  [ "$status" -eq 0 ]
  grep -q "<= b''9405" <(echo "$output")
  echo $output
}

# Path m/44'/309'/1'/1
# 8000002c
# 80000135
# 80000001
# 80000001

# Valid Transaction details
# 94050000 - total length 1428 bytes (including 4 of this length), 2856 in hex encoded message
# 18000000 - 24 bytes
# 30000000
# 48000000
# 4c000000
# 80050000

# Signing path
# 05000000 - length
# 2c000080
# 35010080
# 00000080
# 00000000
# 00000000

# change path (in this case its same as signing path)
# 05000000 - length
# 2c000080
# 35010080
# 00000080
# 00000000
# 00000000

# 02000000 - input count
# Raw transaction
# 34050000 - length 1332 bytes
# 1c000000 - length 28
# 200000006e00000072000000520400002005000000000000
# 02000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000ce0000000c0000006d0000006100000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d61000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d
# 140000000c000000100000000000000000000000
# 140000000c000000100000000000000000000000

@test "Signing with strict checking and a valid useful transaction passes" {
  run sendTransaction 940500001800000030000000480000004c00000080050000050000002c00008035010080000000800000000000000000050000002c0000803501008000000080000000000000000002000000340500001c000000200000006e0000007200000052040000200500000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000ce0000000c0000006d0000006100000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d61000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d140000000c000000100000000000000000000000140000000c000000100000000000000000000000
  rv="$(egrep "<= b'.*'9000" <(echo "$output")|cut -d"'" -f2)"
  txhash_and_witness=21f34fded754e349b5d088c197f7ee091213cfc9e6198639ba5a0359b8952de65500000000000000550000001000000055000000550000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  run check_signature "" "$txhash_and_witness" "$rv"
  diff <(echo $output) - <<<"Signature Verified Successfully"
}

@test "Signing with strict checking and an incorrect context fails" {
  run apdu_fixed "8003400011048000002c800001358000000080000000"
  [ "$status" -eq 0 ]
  grep -q "<= b''9000" <(echo "$output")

  run sendTransaction "940500001800000030000000480000004c00000080050000050000002c00008035010080000000800000000000000000050000002c0000803501008000000080000000000000000002000000340500001c000000200000006e0000007200000052040000200500000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c661436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000ce0000000c0000006d0000006100000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d61000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d140000000c000000100000000000000000000000140000000c000000100000000000000000000000" --expectReject
  grep -q "<= b''9405" <(echo "$output")
  hardRejectionMessageCheck "Context transaction does not match hash"
}

@test "Signing with strict checking of a transaction having a type script fails" {
  run apdu_fixed "8003400011048000002c800001358000000080000000"
  [ "$status" -eq 0 ]
  grep -q "<= b''9000" <(echo "$output")
  run sendTransaction d10500001800000030000000480000004c000000bd050000050000002c00008035010080000000800000000000000000050000002c0000803501008000000080000000000000000002000000710500001c000000200000006e0000007200000052040000550500000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000083d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c0000001800000008000000000000000000000000000000140000000c000000100000000000000000000000 --expectReject
  grep -q "<= b''6982" <(echo "$output")
  rejectionMessageCheck "Only the DAO type script is supported" 2
}

@test "Signing with a transaction having a type script outside of strict checking prompts with a hash" {
  run apdu_fixed "8003400011048000002c800001358000000080000000"
  [ "$status" -eq 0 ]
  grep -q "<= b''9000" <(echo "$output")
  run sendTransaction d10500001800000030000000480000004c000000bd050000050000002c00008035010080000000800000000000000000050000002c0000803501008000000080000000000000000002000000710500001c000000200000006e0000007200000052040000550500000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000083d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c0000001800000008000000000000000000000000000000140000000c000000100000000000000000000000 --no-hard-check
  promptsCheck 2 tests/sign-unsafe-prompts.txt
}

@test "Signing with strict checking and a different change address passes." {

  run sendTransaction 90050000180000003000000044000000480000007c050000050000002c00008035010080000000800000000000000000040000002c00008035010080010000800100008002000000340500001c000000200000006e0000007200000052040000200500000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000ce0000000c0000006d0000006100000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d61000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000b690f63b6fca7abff77c558bffa7401ec40dcb52140000000c000000100000000000000000000000140000000c000000100000000000000000000000
  promptsCheck 4 tests/sign-with-change-path.txt
  rv="$(egrep "<= b'.*'9000" <(echo "$output")|cut -d"'" -f2)"
  txhash_and_witness=56aa7721f93350b942333b389fbdf062d5a5ad86cabe7cb20f7c00bab2d09baf5500000000000000550000001000000055000000550000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  run check_signature "" "$txhash_and_witness" "$rv"
  diff <(echo $output) - <<<"Signature Verified Successfully"
}

@test "Signing with strict checking and more than one destination fails" {
  run sendTransaction 90050000180000003000000044000000480000007c050000050000002c00008035010080000000800000000000000000040000002c00008035010080010000800200008002000000340500001c000000200000006e0000007200000052040000200500000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000ce0000000c0000006d0000006100000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d61000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000b690f63b6fca7abff77c558bffa7401ec40dcb52140000000c000000100000000000000000000000140000000c000000100000000000000000000000 --expectReject
  [ "$status" -eq 0 ]
  grep -q "<= b''6982" <(echo "$output")
  rejectionMessageCheck "Can't handle transactions with multiple non-change destination addresses"
}

@test "Signing with strict checking, a plain transfer, and data in an output cell fails" {
  run sendTransaction 980500001800000030000000480000004c00000084050000050000002c0000803501008000000080000000000000000005000000001c000000200000006e000000b2000000e2000002000000380500001c000000200000006e0000007200000052040000200500000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000ce0000000c0000006d0000006100000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d61000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d180000000c0000001400000004000000deadbeef00000000140000000c000000100000000000000000000000
  [ "$status" -eq 0 ]
  grep -q "<= b''6982" <(echo "$output")
  rejectionMessageCheck "Data found in non-dao cell"
}

@test "Signing with strict checking, a plain transfer, and data in an output cell fails even with eight bytes of data" {
  run sendTransaction 9c0500001800000030000000480000004c00000088050000050000002c000080350100800000008000000000000000000500000001c4000001b80000001c000000200000006e0000020000003c0500001c000000200000006e0000007200000052040000200500000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000e00300000c00000051020000450200000c000000380000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000005207000000000000000000008f0100000c000000380000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000ce0000000c0000006d0000006100000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d61000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c0000001800000008000000deadbeefdeadbeef00000000140000000c000000100000000000000000000000 --expectReject
  [ "$status" -eq 0 ]
  grep -q "<= b''6982" <(echo "$output")
  rejectionMessageCheck "Data found in non-dao cell"
}
