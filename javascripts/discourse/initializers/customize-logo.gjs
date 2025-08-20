import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.34.0", (api) => {
  api.renderInOutlet("home-logo-contents", <template>
    <a class="forum-logo logo_pc" href="/">
    </a>
    <a class="forum-logo logo_mb" href="/">
    </a>
    <span class="divid"></span>
    <a
      class="openubmc-logo lang-zh"
      href="https://www.openubmc.cn"
      target="_blank"
    >
    </a>
    <a
      class="openubmc-logo lang-en"
      href="https://www.openubmc.cn"
      target="_blank"
    >
    </a>
  </template>);
});
