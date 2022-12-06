module.exports = async ({getNamedAccounts, deployments}) => {
  const {deploy} = deployments;
  const {account0} = await getNamedAccounts();

  await deploy("LottoCoin", {
    from: account0,
    args: [],
    log: true,
  });

  await deploy("LottoNFT", {
    from: account0,
    args: [],
    log: true,
  });

  await deploy("Lotto", {
    from: account0,
    args: [],
    log: true,
  });
};