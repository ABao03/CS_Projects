class CandleStick {
  float open;
  float candleHeight;
  float close;
  float currentPosition;
  float candleWidth;

  CandleStick() { // Setting up the initial candlestick
    this.currentPosition = displayWidth/2;
    if (candleNumber == 0) {
      this.open = 400;
    } else { // Using close prices relative to the previous candlestick
      this.open = CandleSticks.get(candleNumber-1).close+random(-20, 20);
    }
    currentSentiment = 4-this.open/100;
    currentSentiment += random(-2-sentimentSlide, 2-sentimentSlide);
    this.candleHeight = zooms == 0 ? (50*currentSentiment*(volatility/5+1)) : (50*currentSentiment*(volatility/5+1)) / (2 * zooms);
    this.close = open + candleHeight;
    this.candleWidth = zooms == 0 ? 50 : 50 / (2 * zooms);
  }

  void drawCandleStick() {
    if (close < open) {
      fill(#00ff26);
    } else {
      fill(#ff0000);
    }
    rect(currentPosition+40, open, candleWidth, candleHeight);
  }
}
