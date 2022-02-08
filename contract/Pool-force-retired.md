# Pool force retired

## 如何检测账号是否被 retired

1. 通过 `pos_getAccount` 方法获取 pos 账户信息，如果 forceRetired 有值，说明被 retire 了。此种方式检测可能会比较延后
2. 如果节点是委员会成员，可以判断 节点是否对最新的 pos block进行了签名操作，如果没有进行可能表示节点不正常

## 节点 retire 带来的影响

1. 如果节点被 retire，节点所有的 votes 会自动被 unlock，从而进入 unlock 队列
2. 新lock 的所有票也会自动进入 unlock 队列，时间为 lock 时间 + unlock 时间，最长 14 天
3. pos 节点的 forceRetired 状态会持续 1 小时 ？ 可能最长七天
4. unlocking 状态的票将不会有收益，意味着在主网环境，矿池用户将损失七天的收益

## 节点 retire 之后需要做什么操作

节点被 retire 之后，合约所记录的 staker 的 vote 状态，跟节点的实际状态将不一致。

处理方式有两种：

1. 在 unlocking 的票达到解锁状态之后，由 pool 的管理员将所有的票重新进行 lock 操作， 此种方式下如果用户想解锁，需要再等待 7 天
2. 将所有用户票的合约状态也改为 unlock 状态，用户需要手动提取所有票，不操作的话也不会有收益