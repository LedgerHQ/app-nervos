
. ./tests/lib.sh


@test "Signing with strict checking and a DAO deposit passes" {
  run apdu_fixed "8003400011048000002c800001358000000080000000"
  [ "$status" -eq 0 ]
  grep -q "<= b''9000" <(echo "$output")
  sendTransaction "840100001c000000200000006e00000072000000a200000070010000000000000200000015fb8111fc78fa36da6af96c45ac4714cc9a33974fdae13cc524b29e1a488c7f030000000007a824df0419adf4c92ca563085525e7224b014ecc97cf3de684dd7b57c0585600000000000000000001000000000000000000000099e225610f6d493a4784eafaf66316f2df8f05312ff816b91eecbb18ce5d1b2401000000ce0000000c0000006d0000006100000010000000180000006100000000d0ed902e000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce801140000000d8502bb8b5b365a69e4e5ed7a3239b9106f9e50610000001000000018000000610000000e909347b300000049000000100000003000000031000000ac8a4bc0656aeee68d4414681f4b2611341c4f0edd4c022f2d250ef8bb58682f0114000000931ca32ee12a6a79d58b9d25a9e75b6929b1b0aa140000000c000000100000000000000000000000" -- isCtxd
  TRANSACTION=c10100001c000000200000006e00000072000000a2000000a5010000000000000200000015fb8111fc78fa36da6af96c45ac4714cc9a33974fdae13cc524b29e1a488c7f020000000084dcb061adebff4ef93d57c975ba9058a9be939d79ea12ee68003f6492448890000000000100000000010000000000000000000000e58df9496d58685516291bf3db0ccbdbc30a53a7316639676b7ad98020d1314600000000030100000c000000a20000009600000010000000180000006100000000ca9a3b00000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce801140000000d8502bb8b5b365a69e4e5ed7a3239b9106f9e503500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000000653552e000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce801140000000d8502bb8b5b365a69e4e5ed7a3239b9106f9e501c0000000c0000001800000008000000000000000000000000000000
  sendTransaction "$TRANSACTION"
  rv="$(egrep "<= b'.*'9000" <(echo "$output")|cut -d"'" -f2)"
  run check_signature "$TRANSACTION" "$rv"
  diff <(echo $output) - <<<"Signature Verified Successfully"
  promptsCheck 4 tests/dao-deposit-prompts.txt
}

@test "Signing with strict checking and a DAO prepare passes" {
  run apdu_fixed "8003400011048000002c800001358000000080000000"
  [ "$status" -eq 0 ]
  grep -q "<= b''9000" <(echo "$output")
  sendTransaction c10100001c000000200000006e00000072000000a2000000a5010000000000000200000084dcb061adebff4ef93d57c975ba9058a9be939d79ea12ee68003f6492448890000000000115fb8111fc78fa36da6af96c45ac4714cc9a33974fdae13cc524b29e1a488c7f020000000000000000010000000000000000000000ae6d3d4667051ab73ed8572e8aba667db718fc96713d50bd754026c83b8f38e001000000030100000c000000a20000009600000010000000180000006100000000c817a804000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000796c1723e1b0feb11942fd6dce32f2f2022aca423500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000080ad1d875f000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce801140000005a62c3f85c248557f81145f2c42de1c1bb69a5041c0000000c0000001800000008000000000000000000000000000000 --isCtxd

  sendTransaction 190200001c000000200000006e00000072000000fa000000fd010000000000000200000084dcb061adebff4ef93d57c975ba9058a9be939d79ea12ee68003f6492448890000000000115fb8111fc78fa36da6af96c45ac4714cc9a33974fdae13cc524b29e1a488c7f020000000000000000030000000000000000000000bc660a567f3f6e9623e478a62f3194b88251f9ff75019a65dac7090305320980010000000000000000000000f04165a65904326f7598428d5be29716bf2cc0e22cd50892bea763129148c33700000000000000000000000008f40515ea510d5b7929d1049d074f2da984f1e8ecb841a1b4ccfe1adba3c90101000000030100000c000000a20000009600000010000000180000006100000080e06b1f05000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000ec907bc438ba0eb0eb5f07593fd5882bcc4bdba83500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e0100000000610000001000000018000000610000002160521802000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e83a7705720be267165f08782b814ef2b08682f91c0000000c0000001800000008000000000000000000000000000000 --isCtxd

  TRANSACTION=0d0200001c000000200000006e00000092000000ee000000f1010000000000000200000084dcb061adebff4ef93d57c975ba9058a9be939d79ea12ee68003f6492448890000000000115fb8111fc78fa36da6af96c45ac4714cc9a33974fdae13cc524b29e1a488c7f0200000000010000000de97120a65cad90742c86cb384eb00bfd5fb38eb1bfaee0a496e41442d5307502000000000000000000000064db458bd2f34361684997c0a6f2fc8eeac1a2f7d8be82b5fb2be02165a3e04a00000000000000000000000020fcaeea9211c22a5ec64d4124e7cd7ab2cec8b96e7ab7c60d5173faeee7be5901000000030100000c000000a20000009600000010000000180000006100000000c817a804000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000796c1723e1b0feb11942fd6dce32f2f2022aca423500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000ff4e521802000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8011400000053c1fd217d7207c793257afc9d6e9b3fb71a0ff91c0000000c0000001800000008000000430700000000000000000000
  sendTransaction "$TRANSACTION"
  rv="$(egrep "<= b'.*'9000" <(echo "$output")|cut -d"'" -f2)"
  run check_signature "$TRANSACTION" "$rv"
  diff <(echo $output) - <<<"Signature Verified Successfully"
  promptsCheck 7 tests/dao-prepare-prompts.txt
}


@test "Signing with strict checking and a DAO withdrawal passes" {
  run apdu_fixed "8003400011048000002c800001358000000080000000"
  [ "$status" -eq 0 ]
  grep -q "<= b''9000" <(echo "$output")

  sendTransaction 0d0200001c000000200000006e00000092000000ee000000f1010000000000000200000084dcb061adebff4ef93d57c975ba9058a9be939d79ea12ee68003f6492448890000000000115fb8111fc78fa36da6af96c45ac4714cc9a33974fdae13cc524b29e1a488c7f020000000001000000c47871ac7fc6babc6d50d0746c4a4c161045bf97c914b6512f72b7b859b536c3020000000000000000000000e768c8f808dc7fd53ea5f513a6c0ba69e44b0dd98596de5344703930e0869fc30000000000000000000000008b5966a41e2edb9ff5a235e9e90b6e340e64ac57e096069ecc07c19a5aa3582700000000030100000c000000a20000009600000010000000180000006100000030e7a26002000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce801140000004cb6874775d45dc34d8fdef092aa566f235d7c203500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000de8c483002000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e404533df5be8e0621affc1a648ee443bb1569931c0000000c0000001800000008000000180700000000000000000000 --isCtxd

  TRANSACTION=570100001c000000200000006e000000b2000000e20000004b010000000000000200000084dcb061adebff4ef93d57c975ba9058a9be939d79ea12ee68003f6492448890000000000115fb8111fc78fa36da6af96c45ac4714cc9a33974fdae13cc524b29e1a488c7f020000000002000000c47871ac7fc6babc6d50d0746c4a4c161045bf97c914b6512f72b7b859b536c3fc279890a9398df4dac82391ae3a575b3498b0971f8cca333ce183bcbd018f5d01000000b600003c015c02205023434a632e742ffdfddc9a1aaed6bc9b05b34281db62c353a6e7c5266a2c1e000000006900000008000000610000001000000018000000610000004afda26002000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000ad9144f3b893d1e46aaf31b9f0866ec44a4bf5160c0000000800000000000000

  sendTransaction "$TRANSACTION"
  rv="$(egrep "<= b'.*'9000" <(echo "$output")|cut -d"'" -f2)"
  run check_signature "$TRANSACTION" "$rv"
  diff <(echo $output) - <<<"Signature Verified Successfully"
  promptsCheck 6 tests/dao-withdraw-prompts.txt
}
