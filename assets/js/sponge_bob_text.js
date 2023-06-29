const SpongeBobText = {
  mock_me_not(text) {
    return [...text]
      .map((ch) =>
        Math.round(Math.random()) ? ch.toLowerCase() : ch.toUpperCase()
      )
      .join("");
  },
  mounted() {
    this.timer = setInterval(() => {
      this.el.innerHTML = this.mock_me_not(this.el.innerHTML);
    }, 5000);
  },
  destroyed() {
    clearTimeout(this.timer);
  },
};

export default SpongeBobText;
