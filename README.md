# EthDenver Bootcamp FInal Project

## coded by Team 8 (I think lol ) :
  * @kylemilden237
  * @JohnGkliatis
  * @0xwaya
 

 ### Concept:
 - create token to mint using burn to mint NFT function
 - NFT with chainlink vrf randomness funtion to select lotery winner among NFT holders
 - contract testing using foundry



#### Useful scripts:

##### Installation via Python:

Installation:

```
python3 -m pip install --user pipx
python3 -m pipx ensurepath
```
##### restart your terminal
```
pipx install eth-brownie
```
##### Or, if that doesn't work, via pip
```
pip install eth-brownie
```

##### Download the mix and install dependencies.
```
brownie bake chainlink-mix
cd chainlink-mix
pip install -r requirements.txt
```



Chainlink VRF
This will deploy a smart contract to kovan and get a Random number via Chainlink VRF.

```
brownie run scripts/vrf_scripts/01_deploy_vrf.py --network kovan
brownie run scripts/vrf_scripts/02_request_randomness.py --network kovan
brownie run scripts/vrf_scripts/03_read_random_number.py --network kovan
```
