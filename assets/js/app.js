// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Clipboard from "./clipboard";
import DarkModeToggle from "./dark_mode_toggle";
import Ping from "./ping";
import CommandPallete from "./command_pallete";
import SpongeBobText from "./sponge_bob_text";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  metadata: {
    keydown: (e, el) => {
      return {
        key: e.key,
        metaKey: e.metaKey,
      };
    },
  },
  hooks: {
    Clipboard,
    DarkModeToggle,
    Ping,
    CommandPallete,
    SpongeBobText,
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// liveSocket.enableDebug()
// liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// liveSocket.disableLatencySim();
window.liveSocket = liveSocket;

window.addEventListener("phx:copy", (event) => {
  // let text = event.target.value; // Alternatively use an element or data tag!
  let text = event.target.innerHTML;
  navigator.clipboard.writeText(text).then(() => {
    console.log("All done!"); // Or a nice tooltip or something.
  });
});

window.addEventListener("phx:focus", (event) => {
  event.target.focus();
});
