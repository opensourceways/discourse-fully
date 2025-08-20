import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.34.0", (api) => {
  api.renderInOutlet("home-logo-contents", <template>
    <a class="forum-logo logo_pc" href="/">
    </a>
    <a class="forum-logo logo_mb" href="/">
    </a>
    <span class="divid"></span>
    <a
      class="openeuler-logo lang-zh"
      href="https://www.openeuler.org/zh/"
      target="_blank"
    >
    </a>
    <a
      class="openeuler-logo lang-en"
      href="https://www.openeuler.org/en/"
      target="_blank"
    >
    </a>
  </template>);
});
