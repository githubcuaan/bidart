/// Foul classification per step1/rule.md. Old WPA-style FoulType excluded.
/// - none: no foul (legal pot keeps turn, miss passes turn).
/// - th1: foul on a later turn after a legal pot in the chain;
///   scores/order kept, next player continues.
/// - th2: foul before any legal pot in the chain; swap with payer.
/// - potAndFoul: pot + foul in the same turn; reverse points, swap as TH2.
enum FoulClassification { none, th1, th2, potAndFoul }
