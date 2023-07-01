const ScrollIntoView = {
  mounted() {
    this.el.scrollIntoView({
      behavior: "smooth",
      block: "start",
      inline: "end",
    });
  },
};

export default ScrollIntoView;
