const Ping = {
  mounted() {
    this.handleEvent("pong", () => {
      let rtt = Date.now() - this.nowMs;
      this.el.innerText = `${rtt}ms`;
      this.timer = setTimeout(() => this.ping(rtt), 1000);
    });
    this.ping(null);
  },
  reconnected() {
    clearTimeout(this.timer);
    this.ping(null);
  },
  destroyed() {
    clearTimeout(this.timer);
  },
  ping(rtt) {
    this.nowMs = Date.now();
    this.pushEvent("ping", { rtt: rtt });
  },
};

export default Ping;
