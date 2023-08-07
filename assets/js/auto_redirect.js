const AutoRedirect = {
  mounted() {
    setTimeout(() => {
      this.pushEvent(
        "navigate",
        "/blog/taskfile-a-sensible-makefile-and-shell-script-alternative"
      );
    }, 3000);
  },
};

export default AutoRedirect;
