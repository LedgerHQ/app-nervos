# Overview

This repository contains the Nervos BOLOS application for the Ledger Nano S and Ledger Nano X and tools for testing the application. While this app is currently under development, we do not recommend using it with mainnet CKB. 

This application has been developed against our forks of [CKB-CLI](https://github.com/obsidiansystems/ckb-cli) and [CKB](https://github.com/obsidiansystems/ckb). Most instructions assume you have the [Nix](https://nixos.org/nix/) Package Manager, which you can install on any Linux distribution or MacOS. Application and wallet developers who would like to support Ledger can do so with [LedgerJS](https://github.com/obsidiansystems/ledgerjs/tree/nervos).

# System Requirements

System requirements differ based on if you are using or installing the application. If you are using a Linux machine, you will need to [Prepare your Linux Machine for Ledger Device Communication](#preparing-your-linux-machine-for-ledger-device-communication).

## For Application Installation

Installation requirements differ based on installation method:

- **Installing with Ledger Live**: [Ledger Live](https://www.ledger.com/ledger-live) is the easiest way to install applications on your Ledger device. Please refer to [Ledger Live's system requirements](https://support.ledger.com/hc/en-us/articles/360006395553-Download-and-install-Ledger-Live) for this installation method. This application is still in active development and not yet available in Ledger Live.
- **Installing Release Files**: Release files can be installed using Linux and Mac. Windows is not supported.
- **Installing from Source**: The application can be built from source and installed on Linux machines with the Nix Package Manager.

This applications are built against Ledger Nano S firmware 1.6.0 and Ledger Nano X firmware XXX. Please use [Ledger Live](https://www.ledger.com/ledger-live) to manage your Ledger device's firmware.

## For Application Usage

Most of the instructions in this README cover how to use the Ledger application with Nervos' client, [CKB-CLI](https://github.com/nervosnetwork/ckb-cli). If you have installed CKB-CLI from its upstream location, please refer to their system requirements.

If you are using this application with a wallet, please refer to that wallet's system requirements.

## Preparing Your Linux Machine for Ledger Device Communication

On Linux, the "udev" rules must be set up to allow your user to communicate with the ledger device.

### NixOS

On NixOS, one can easily do this with by adding the following to configuration.nix:
``` nix
{
  # ...
  hardware.ledger.enable = true;
  # ...
}
```

### Non-NixOS Linux Distros

For non-NixOS Linux distros, LedgerHQ provides a [script](https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh) for this purpose, in its own [specialized repo](https://github.com/LedgerHQ/udev-rules). Download this script, read it, customize it, and run it as root:

```
$ wget https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh
$ chmod +x add_udev_rules.sh
```

We recommend against running the next command without reviewing the script and modifying it to match your configuration.

```
$ sudo ./add_udev_rules.sh
```

Subsequently, unplug your ledger hardware wallet, and plug it in again for the changes to take effect.

For more details, see [Ledger's documentation](https://support.ledger.com/hc/en-us/articles/115005165269-Fix-connection-issues).

# Ledger App Installation

There are 3 ways you can install this Ledger application:
1. Ledger Live *(not yet available)*: [Ledger Live](https://www.ledger.com/ledger-live) is the easiest way to install applications on your Ledger device. However, this application is still in active development and not yet available in Ledger Live.
2. [Installing from Release](#Installing-The-Ledger-Application-from-Release): This is the recommended installation method until this app is available in Ledger Live.
3. Installing from Source: Recommended for development only.

*Note: You can only install applications on the Ledger Nano X through Ledger Live.*

## Installing the Ledger Application from Release

Please download `nano-s-release.tar.gz` from the latest release on  the [releases](https://github.com/obsidiansystems/ledger-app-nervos/releases) page of this repo, which contains a pre-compiled app or `.hex` file ready to install on the Ledger. The following sections describe how to install it, including acquiring other tools from the Ledger project.

### Installing BOLOS Python Loader

Install `libusb` and `libudev`, with the relevant headers. On Debian-based distros, including Ubuntu, the packages with the headers are suffixed with `-dev`. Other distros will have their own conventions. So, for example, on Ubuntu, you can do this with:

```
$ sudo apt-get install libusb-1.0.0-dev libudev-dev # Ubuntu example
```

Then, install `pip3`. You must install `pip3` for this and not `pip`. On Ubuntu:

```
$ sudo apt-get install python3-pip # Ubuntu example
```

Now, on any operating system, install `virtualenv` using `pip3`. It is important to use `pip3` and not `pip` for this, as this module requires `python3` support.

```
$ sudo pip3 install virtualenv # Any OS
```

Then create a Python virtual environment (abbreviated *virtualenv*). You could call it anything, but we shall call it "ledger". This will create a directory called "ledger" containing the virtualenv:

```
$ virtualenv ledger # Any OS
```

Then, you must enter the `virtualenv`. If you do not successfully enter the `virtualenv`, future commands will fail. You can tell you have entered the virtualenv when your prompt is prefixed with `(ledger)`.

```
$ source ledger/bin/activate
```

Your terminal session -- and only that terminal session -- will now be in the virtual env. To have a new terminal session enter the virtualenv, run the above `source` command only in the same directory in the new terminal session.

### ledgerblue: The Python Module for Ledger Nano S/X

We can now install `ledgerblue`, which is a Python module designed originally for Ledger Blue, but also is needed for the Ledger Nano S/X.

Although we do not yet support Ledger Blue, you must still install the following python package. Within the virtualenv environment -- making sure that `(ledger)` is showing up before your prompt -- use pip to install the `ledgerblue` [Python package](https://pypi.org/project/ledgerblue/). This will install the Ledger Python packages into the virtualenv; they will be available only in a shell where the virtualenv has been activated.

```
$ pip install ledgerblue
```

If you have to use `sudo` or `pip3` here, that is an indication that you have not correctly set up `virtualenv`. It will still work in such a situation, but please research other material on troubleshooting `virtualenv` setup.

### Load the Application onto the Ledger Device

Next you'll use the installation script to install the application on your Ledger device.

The Ledger device must be in the following state:

  * Plugged into your computer
  * Unlocked (enter your PIN)
  * On the home screen (do not have any application open)
  * Not asleep (you should not see *vires in numeris* is scrolling across the
    screen)

If you are already in an application or the Ledger device is asleep, your installation process will fail.

We recommend staying at your computer and keeping an eye on the Ledger device's screen as you continue. You may want to read the rest of these instructions before you begin installing, as you will need to confirm and verify a few things during the process.

Still within the virtualenv, run the `./install.sh` command included in the `nano-s-release.tar.gz` that you downloaded. This `./install.sh` script takes the path to an application directory. The only such directory included in the downloaded `release.tar.gz` will be `app`, so install the app like this, replacing `~/Downloads/` with whatever directory you downloaded the file into:

```
cd ~/Downloads/
tar xzf nano-s-release.tar.gz
cd ledger-app-nervos-s
./install.sh app
```

The first thing that should come up in your terminal is a message that looks like this:

```
Generated random root public key : <long string of digits and letters>
```

Look at your Ledger device's screen and verify that the digits of that key match the digits you can see on your terminal. What you see on your Ledger hardware wallet's screen should be just the beginning and ending few characters of the longer string that printed in your terminal.

You will need to push confirmation buttons on your Ledger device a few times during the installation process and re-enter your PIN code near the end of the process. You should finally see the Nervos logo appear on the screen.

If you see the "Generated random root public key" message and then something that looks like this:

```
Traceback (most recent call last):
File "/usr/lib/python3.6/runpy.py", line 193, in _run_module_as_main
<...more file names...>
OSError: open failed
```

the most likely cause is that your `udev` rules are not set up correctly, or you did not unplug your Ledger hardware wallet between setting up the rules and attempting to install. Please confirm the correctness of your `udev` rules.

To load a new version of the Nervos application onto the Ledger device in the future, you can run the command again, and it will automatically remove any previously-loaded version.

## Installing the Ledger Application from Source

You can install the Ledger app from source if you have Nix installed. To load the latest version of the Nervos app:

``` sh
$ git clone https://github.com/obsidiansystems/ledger-app-nervos.git
$ cd ledger-app-nervos
$ git checkout master
$ ./nix/install.sh s
```
Some notes during app installation:
- 'Starting bats': When building and installing the application from source, the client will run a suite of tests found in the `tests.sh` file. 'bats' stands for "[Bash Automated Testing System](https://github.com/bats-core/bats-core)". These tests may take some time to complete. When they are done, the app installation will proceed.
These tests must complete before the app installation and they may take some time. You have not hit an error, 
- Unsafe Manager: you will see a prompt to either allow or deny 'unsafe manager' when running `./nix/install.sh s`. 'Unsafe Manager' is any manager which is not Ledger Live.
- Permission Denied: If you get a “permission denied” error, your computer is not detecting the Ledger device correctly. Make sure the Ledger is connected properly, that it was plugged in since updating the `udev` rules.

You have to accept a few prompts on the Ledger. Then you must select and load the Nervos app.

### Confirming the Installed Version

To confirm the version of the application installed on your hardware wallet, first make sure the Ledger device is: 

- connected
- unlocked
- has the “Nervos” app open (shows “Use wallet to view accounts”)

Then run the following: 

``` sh
./check-installed-version.sh

```

If the results of that command match the results of `git rev-parse --short HEAD`, the installation was successful.

# Using the Client

## Installing the Client

To use the CKB command line utility with the Ledger, you must currently use the Obsidian fork of the client. To build and start it, run:

``` sh
$ nix run -f nix/dep/ckb-cli -c ckb-cli
```

All commands that follow prefixed with ‘CKB>’ should be run in the prompt provided by the above command.

## List Ledger Wallets ###

Use the `account list` command to see connected Ledger devices. Be sure to have the Nervos application open on the device, otherwise it will not be detected:

``` sh
CKB> account list
- "#": 0
  account_source: ledger hardware wallet
  ledger_id: 0x69c46b6dd072a2693378ef4f5f35dcd82f826dc1fdcc891255db5870f54b06e6
```

The `ledger_id` shown is the public key hash for the path m/44'/309', which is the root Nervos path. the `ledger\_id` will be
used for ```<ledger-id>``` argument in the `account import` command as described below.

If you have already imported the Ledger account, then `account list` command will instead give the account details.
This will be shown even if the device is not connected.

``` sh
CKB> account list
- "#": 0
  account_source: ledger hardware wallet
  address:
    mainnet: ckb1qyqry754h4tevmngdll9jrpnrnfhqqhpcccskdl3en
    testnet: ckt1qyqry754h4tevmngdll9jrpnrnfhqqhpcccstgpw40
  lock_arg: 0x327a95bd57966e686ffe590c331cd37002e1c631
  lock_hash: 0xc27b9ad3414cf5b1720713663d5f754e8968793f2da90b6428feb565bf94de4e
```

## Import Ledger Wallet account ###

Use the `account import --ledger <ledger_id>` command to import the account to the `ckb-cli`.
You will receive a confirmation prompt on the device which should say `Import Account`.
Confirm this to import the account. This operation will provide the extended public key of path `m/44'/309'/0'` to the `ckb-cli`.

``` sh
CKB> account import --ledger 0x69c46b6dd072a2693378ef4f5f35dcd82f826dc1fdcc891255db5870f54b06e6
- "#": 0
  account_source: ledger hardware wallet
  address:
    mainnet: ckb1qyqry754h4tevmngdll9jrpnrnfhqqhpcccskdl3en
    testnet: ckt1qyqry754h4tevmngdll9jrpnrnfhqqhpcccstgpw40
  lock_arg: 0x327a95bd57966e686ffe590c331cd37002e1c631
  lock_hash: 0xc27b9ad3414cf5b1720713663d5f754e8968793f2da90b6428feb565bf94de4e
```

Now that the account has been imported, it is remembered by the client and is visible when you run `account list`.

### Get BIP44 Wallet Public Keys ###

Use the `account bip44-addresses` command to obtain the BIP44 addresses for the mainnet.

Note that this command is provided as a convenience by the `ckb-cli` to get a list of addresses with the derivation path quickly.

**It is highly recommended to verify the account provided by this command on the Ledger device using the `account extended-address` command as described next.**

``` sh
CKB> account bip44-addresses --lock-arg 0x327a95bd57966e686ffe590c331cd37002e1c631
```

### Obtain / Verify Public Key ###

The `account extended-address` command should be used to

- Verify the public key obtained via `account bip44-addresses` command on the Ledger device
- Obtain the public key for any arbitrary BIP44 derivation path

``` sh
CKB> account extended-address --path "m/44'/309'/0'/0/1" --lock-arg 0x327a95bd57966e686ffe590c331cd37002e1c631
```

This should show up on the ledger as (in 2 screens):

``` text
Provide 
Public Key
```
``` text
Address:
ckb1qyqxxtzygxvjwhgqklqlkedlqqwhp0rqjkvsqltkvh
```
If you've changed the Ledger's configuration to show testnet address, the last screen will instead look like this:

``` text
Address:
ckt1qyqxxtzygxvjwhgqklqlkedlqqwhp0rqjkvsa64fqt
```

After accepting the prompt on the Ledger the output on `ckb-cli` should look like:
 
``` text
address:
  mainnet: ckb1qyqxxtzygxvjwhgqklqlkedlqqwhp0rqjkvsqltkvh
  testnet: ckt1qyqxxtzygxvjwhgqklqlkedlqqwhp0rqjkvsa64fqt
lock_arg: 0x632c444199275d00b7c1fb65bf001d70bc609599
lock_hash: 0xee0283c2d991992d6e015a4680c54318ad42c820ca0dc862c0a1d68c415499a8
```

**It is highly recommended to verify that output address printed by `ckb-cli` matches the one shown on Ledger prompt**

The “testnet” address is the one used for `<ledger-address>` in the next section.

## Transferring ###

### Creating a new account for local dev network ####

Now, you must also create an account from ckb-cli so that an account
can get the issued cells. This can be done with:

```
CKB> account new
```

Follow the prompts and choose a password to continue. Next, get the
lock_arg for your account with:

```
CKB> account list
- "#": 0
  account_source: on-disk password-protected key store
  address:
    mainnet: ckb1qyq2htkmhdkcmcwc44xsxc3hcg7gytuyapcqpwltnt
    testnet: ckt1qyq2htkmhdkcmcwc44xsxc3hcg7gytuyapcqutp5lh
  lock_arg: 0xabaedbbb6d8de1d8ad4d036237c23c822f84e870
  lock_hash: 0x21ad4eee4fb0f079f5f8166f42f0d4fbd1fd63b8f36a7ccfb9d3657f9a5aed43
- "#": 1
  account_source: ledger hardware wallet
  address:
    mainnet: ckb1qyqry754h4tevmngdll9jrpnrnfhqqhpcccskdl3en
    testnet: ckt1qyqry754h4tevmngdll9jrpnrnfhqqhpcccstgpw40
  lock_arg: 0x327a95bd57966e686ffe590c331cd37002e1c631
  lock_hash: 0xc27b9ad3414cf5b1720713663d5f754e8968793f2da90b6428feb565bf94de4e
```

The value of “lock_arg: ...” is your-new-account-lock-arg.

### Starting a local dev network ####

Our instructions for starting a devnet are based on [Nervos' Dev Chain docs](https://docs.nervos.org/dev-guide/devchain.html). First, make a directory and init it for a dev network:
``` sh
$ nix run -f nix/dep/ckb # to make ckb available
$ mkdir devnet
$ cd devnet
$ ckb init --chain dev
```

then modify the value at the end of ckb-miner.toml to be small:

```
value = 20
```

and also add this block to the end of ckb.toml:

```
[block_assembler]
code_hash = "0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8"
args = "0xb57dd485a1b0c0a57c377e896a1a924d7ed02ab9"
hash_type = "type"
message = "0x"
```

finally, in specs/dev.toml, set genesis\_epoch\_length to 1 and
uncomment permanent\_difficulty\_in\_dummy:

```
genesis_epoch_length = 1
# For development and testing purposes only.
# Keep difficulty be permanent if the pow is Dummy. (default: false)
permanent_difficulty_in_dummy = true
```

and also pick one of the genesis issuance cells and set args to a lock
arg from password-protected account above:

```
[[genesis.issued_cells]]
capacity = 20_000_000_000_00000000
lock.code_hash = "0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8"
lock.args = "<your-new-account-lock-arg>"
lock.hash_type = "type"
```

Then you can run 

```
ckb run &
ckb miner
```

to start up the node and miner; the ledger account you added to
genesis.issued\_cells should have a large quantity of CKB to spend
testing.

Note that you may have to suspend your miner to avoid hitting the
maximum amount of deposited cells. You can do this with Ctrl-Z. Type
‘fg’ followed by enter to continue running it later. The miner should
be running when running any ckb-cli commands.

### Getting CKB from the miner ####

The dev network is set up to send CKBs to the on-disk account. To get
money onto the Ledger, you need to do a transfer. This can be done
with an initial transfer:

```
CKB> wallet transfer --from-account <your-new-account-lock-arg> --to-address <ledger-address> --capacity 1000 --tx-fee 0.001
```

### Verify address balance ####

To continue, you need at least 100 CKB in your wallet. Do this with:

``` sh
CKB> wallet get-capacity --address <ledger-address>
total: 100.0 (CKB)
```

If your node is not synced up, this will take up to a few hours. If
the number is less than 100, you need to somehow get the coins some
other way.

### Transfer ####

Transfer operation (use correct --from-account and
derive-change-address value from “List Ledger Wallets” and “Get Public
Key” above).

``` sh
CKB> wallet transfer \
    --from-account <ledger-account-lock-arg> \
    --to-address <ledger-address> \
    --capacity 102 --tx-fee 0.00001 \
    --derive-change-address <ledger-address> \
    --derive-receiving-address-length 0 \
    --derive-change-address-length 1
```

#### Get live cells ######

Get live cells:

``` sh
CKB> wallet get-live-cells --address <ledger-address>
current_capacity: 2000.0 (CKB)
current_count: 1
live_cells:
  - capacity: 2000.0 (CKB)
    data_bytes: 0
    index:
      output_index: 0
      tx_index: 2
    lock_hash: 0x8cf5955c203e3bd9c0fa1ceac94206dca01e32a674ba17060e77f8e52750e491
    mature: true
    number: 460368
    tx_hash: 0xe58df9496d58685516291bf3db0ccbdbc30a53a7316639676b7ad98020d13146
    tx_index: 0
    type_hashes: ~
total_capacity: 2000.0 (CKB)
total_count: 1
```

### Message Signing ####
To sign a message with their ledger a user may do the following:

```sh
CKB> util sign-message --message "hello world i love nervos" --account <my-ledger-account>
message-hash: <blake2b hash of: magic_bytes + message>
recoverable: false
signature: <signature>

CKB> util verify-message --message "hello world i love nervos" --account <my-ledger-account> --signature <signature from above>
pubkey: <pubkey of my ledger's account root>
recoverable: false
verify-ok: true
```
If a message is longer than 64 characters the ledger will display the first 61 chars, followed by an ellipsis (`...`)
The ckb-cli accepts utf8 strings in its `--message` argument, but the ledger can not display all chars. If the ledger comes accross a
character that it is unnable to display it will display an asterisk (`\*`) instead.

### DAO ####

#### Deposit #####

You can deposit to the dao like:

``` sh
CKB> dao deposit \
    --capacity 102 \
    --from-account <ledger-id> \
    --tx-fee 0.00001 \
    --path "m/44'/309'/0'/1/0"
```
Prompts on the Ledger device are as follows:
``` text
Confirm DAO
Deposit
```
``` text
Amount
102
```
``` text
Fee
0.00001
```
``` text
Source
ckt1qyq2htkmhdkcmcwc44xsxc3hcg7gytuyapcqutp5lh
```
#### Get deposited cells #####

Get deposited cells:

``` sh
CKB> dao query-deposited-cells --address <ledger-address>
live_cells:
  - capacity: 10200000000
    data_bytes: 8
    index:
      output_index: 0
      tx_index: 1
    lock_hash: 0xa77a89c29289311b5d6a01f234facc8244cf455909260533e11183054852ff61
    number: 472898
    tx_hash: 0xc55bad328edd74c4be1e630d0eb52733d9ed027f02eaca10f0e78b96a44053fc
    tx_index: 0
    type_hashes:
      - 0x82d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e
      - 0xcc77c4deac05d68ab5b26828f0bf4565a8d73113d7bb7e92b8362b8a74e58e58
total_capacity: 10200000000
```

Remember the values above for one of the live cells under “tx\_hash” and “output\_index”. You'll need these when constructing the `prepare` operation below which prepares a cell for withdrawal from the NervosDAO.

#### Prepare #####

Prepare a cell for withdrawal from the NervosDAO:

``` sh
CKB> dao prepare \
    --from-account <ledger-id> \
    --out-point <tx_hash>-<output_index> \
    --tx-fee 0.0001 \
    --path "m/44'/309'/0'/1/0"
```
Prompts on the Ledger device are as follows:
``` text
Confirm DAO
Prepare
```
``` text
Amount
102
```
``` text
Fee
0.00001
```
``` text
Owner
ckt1qyq2htkmhdkcmcwc44xsxc3hcg7gytuyapcqutp5lh
```
``` text
Fee payer
ckt1qyq2htkmhdkcmcwc44xsxc3hcg7gytuyapcqutp5lh
```

##### Get prepared cells #####

Get prepared cells:

``` sh
CKB> dao query-prepared-cells --address <ledger-address>
live_cells:
  - capacity: 10500000000
    data_bytes: 8
    index:
      output_index: 0
      tx_index: 1
    lock_hash: 0xa77a89c29289311b5d6a01f234facc8244cf455909260533e11183054852ff61
    maximum_withdraw: 10500154580
    number: 493786
    tx_hash: 0xae91f2a310f2cfeada391e5f76d0addcc56d99c91a39734c292c930a1cfc67c2
    tx_index: 0
    type_hashes:
      - 0x82d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e
      - 0xcc77c4deac05d68ab5b26828f0bf4565a8d73113d7bb7e92b8362b8a74e58e58
total_maximum_withdraw: 10500154580
```

Remember the values above for one of the live cells under “tx\_hash” and “output\_index”. You'll need these when constructing the `withdraw` operation below which withdraws CKB from the NervosDAO.

#### Withdraw #####

Withdraw a prepared cell:

``` sh
CKB> dao withdraw \
    --from-account <ledger-id> \
    --out-point <tx_hash>-<output_index> \
    --tx-fee 0.00001 \
    --path "m/44'/309'/0'/1/0"
```
Prompts on the Ledger device are as follows:
``` text
Confirm DAO
Withdraw
```
``` text
Amount
102
```
``` text
Fee
0.00001
```
``` text
Owner
ckt1qyq2htkmhdkcmcwc44xsxc3hcg7gytuyapcqutp5lh
```
``` text
Fee payer
ckt1qyq2htkmhdkcmcwc44xsxc3hcg7gytuyapcqutp5lh
```

If you attempt to withdraw from the Nervos DAO prematurely, you'll see an error such as 
```
JSON-RPC 2.0 Error: Server error (Transaction: Immature)
```
or 
```
JSON-RPC 2.0 Error: Server error (OutPoint: ImmatureHeader(Byte32(0xd7de1ffd49c71b5dc71fcbf1638bb72c8fb16f8fffdfd5172456a56167fea0a3)))
```
This means your prepared cell is not yet available to withdraw. You'll need to wait for the conclusion of your current deposit period before withdrawing.

# Running the testnet #

You can also run the above commands in the testnet instead of a
devnet. This allows you to make transactions that are sent to the
wider test network. Note that this means you will have to wait the 30
day period for doing a DAO withdraw.

Get ckb in your shell:

``` sh
$ nix run -f ./nix/dep/ckb
```

Create a testnet directory

```
$ mkdir -p testnet
$ cd testnet/
```

Get aggron.toml:

``` sh
$ curl -o aggron.toml https://gist.githubusercontent.com/doitian/573513c345165c0fe4f3504ebc1c8f9f/raw/3032bed68550e0a50e91df2c706481e80b579c70/aggron.toml
```

Init the testnet toml:

``` sh
$ ckb init --import-spec ./aggron.toml --chain testnet
```

Run the node with:

```
$ ckb run
```

Leave this open in a separate terminal as you continue on the next steps.


# Troubleshooting #

## Application Build Failure ##

If you run into issues building the Ledger application using `nix-shell -A wallet.s --run 'make SHELL=sh all'`, we recommend trying `nix-shell -A wallet.s --run 'make SHELL=sh clean all`.

## Devnet stops at 59594 blocks ##

At some point, you hit an issue where the node can’t hold the capacity of the miner. This can be resolved by, clearing your devnet and restarting like so:

``` sh
CTRL-C
$ rm -rf data/
$ ckb run &
$ ckb miner
```

## Invalid cell status ##

This can happen when you have switched networks between running
ckb-cli. If this is the case, it can be fixed by clearing your cache.
This can be done on the command line.

First, quit out of ckb-cli so that we can modify our index by typing
‘quit’. Then, clear your cache with:

``` sh
$ rm -rf $HOME/.ckb-cli/index-v1/
```
