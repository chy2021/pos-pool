//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IPoSPool.sol";

contract PoolManager is Ownable {
  using EnumerableSet for EnumerableSet.AddressSet;

  // uint32 constant public RATIO_BASE = 10000;

  EnumerableSet.AddressSet private pools;

  struct PoolInfo {
    uint32 apy; // 1000 / 1w  10%
    uint32 fee; // userShare fee   90%
    uint64 totalAvailable;
    address poolAddress;
    string name;
  }

  constructor() {}

  // TODO pagination
  function getPools() public view returns (PoolInfo[] memory) {
    PoolInfo[] memory poolInfos = new PoolInfo[](pools.length());

    address[] memory poolAddresses = pools.values();
    for (uint32 i = 0; i < poolAddresses.length; i++) {
      IPoSPool poolInstance = IPoSPool(poolAddresses[i]);
      poolInfos[i] = PoolInfo({
        poolAddress: poolAddresses[i],
        totalAvailable: poolInstance.poolSummary().available,
        name: poolInstance.poolName(),
        apy: poolInstance.poolAPY(),
        fee: poolInstance.poolUserShareRatio()
      });
    }
    
    return poolInfos;
  }

  function addPool(address poolAddress) public onlyOwner {
    pools.add(poolAddress);
  }

  function removePool(address poolAddress) public onlyOwner {
    pools.remove(poolAddress);
  }

}