module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
   networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id，
      from:'0xFe8196df811986f69A5320435bf401B8a7064B0a',
    }
  }
};
