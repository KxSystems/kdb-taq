/Following comment added Wed 10 JAN 17:57
/This is the second edit to a script in order to test the staging/committing of files with git

// schema.q
// Quote Table Schema
quote:([]time:`timestamp$();sym:`symbol$();bid:`float$();ask:`float$();bsize:`long$();asize:`long$());
// trade Table Schema
trade:([]time:`timestamp$();sym:`symbol$();price:`float$();size:`long$());
// Aggregation Table Schema
aggTrade:([sym:`symbol$()];time:`timestamp$();maxTPrice:`float$();minTPice:`float$();tVolume:`long$();bestBid:`float$();bestAsk:`float$());
