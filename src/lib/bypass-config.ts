export interface LinkConfig {
  name: string;
  regex: RegExp;
  userscript_regex: string | string[];
  valid_url_regex: RegExp;
  url_base: string;
}

export const regexObjects: LinkConfig[] = [
  {
    name: "adshrink",
    regex: /^https?:\/\/(www\.)?(adshnk\.com|adshrink\.it|shrink-service\.it)/i,
    userscript_regex: ["*://*.adshnk.com/*", "*://*.adshrink.it/*", "*://*.shrink-service.it/*"],
    valid_url_regex: /^https?:\/\/(www\.)?(adshnk\.com|adshrink\.it|shrink-service\.it)\/.+/,
    url_base: "https://adshnk.com"
  },
  {
    name: "adfocus",
    regex: /^https?:\/\/adfoc\.us/i,
    userscript_regex: "*://adfoc.us/*",
    valid_url_regex: /^https?:\/\/adfoc\.us\/(?:\d+|serve\/\?id=\d+)$/,
    url_base: "https://adfoc.us"
  },
  {
    name: "boost.ink",
    regex: /^https?:\/\/(boost\.ink|bst\.gg|bst\.wtf|booo\.st)/i,
    userscript_regex: [
      "*://boost.ink/*",
      "*://bst.gg/*",
      "*://bst.wtf/*",
      "*://booo.st/*"
    ],
    valid_url_regex: /^https?:\/\/(boost\.ink|bst\.gg|bst\.wtf|booo\.st)\/[a-zA-Z0-9_]+\/?$/,
    url_base: "https://boost.ink"
  },
  {
    name: "boost.fusedgt",
    regex: /^https?:\/\/boost\.fusedgt\.com/i,
    userscript_regex: "*://boost.fusedgt.com/*",
    valid_url_regex: /^https?:\/\/boost\.fusedgt\.com\/.+/,
    url_base: "https://boost.fusedgt.com"
  },
  {
    name: "dragonslayer",
    regex: /^(https?:\/\/)?thedragonslayer2\.github\.io\/.*$/i,
    userscript_regex: "*://thedragonslayer2.github.io/*",
    valid_url_regex: /^https?:\/\/thedragonslayer2\.github\.io\/GetKey\.html\?\w+$/,
    url_base: "https://thedragonslayer2.github.io"
  },
  {
    name: "empebau",
    regex: /^https?:\/\/empebau\.eu/i,
    userscript_regex: "*://empebau.eu/*",
    valid_url_regex: /^https?:\/\/empebau\.eu\/s\/(linker\/)?[a-zA-Z0-9-]+$/,
    url_base: "https://empebau.eu"
  },
  {
    name: "google_url",
    regex: /https?:\/\/www\.google\.com\/url/,
    userscript_regex: "*://www.google.com/url*",
    valid_url_regex: /https?:\/\/www\.google\.com\/url.+/,
    url_base: "https://www.google.com/url"
  },
  {
    name: "is.gd",
    regex: /^https?:\/\/is\.gd/i,
    userscript_regex: "*://is.gd/*",
    valid_url_regex: /^https?:\/\/is\.gd\/[a-zA-Z0-9-_]+$/,
    url_base: "https://is.gd"
  },
  {
    name: "justpaste",
    regex: /https?:\/\/justpaste\.it\/redirect\/[0-9a-z]+\//,
    userscript_regex: "*://justpaste.it/redirect/*",
    valid_url_regex: /https?:\/\/justpaste\.it\/redirect\/[0-9a-z]+\//,
    url_base: "https://justpaste.it"
  },
  {
    name: "leasurepartment",
    regex: /^(https?:\/\/)?leasurepartment\.xyz\/.*$/i,
    userscript_regex: "*://leasurepartment.xyz/*",
    valid_url_regex: /^https?:\/\/leasurepartment\.xyz\/\?h=[^&]+&tid=\d+&cc=[^&]+$/,
    url_base: "https://leasurepartment.xyz"
  },
  {
    name: "letsboost",
    regex: /^https?:\/\/letsboost\.net/i,
    userscript_regex: "*://letsboost.net/*",
    valid_url_regex: /^https?:\/\/letsboost\.net\/[a-zA-Z0-9-_]+$/,
    url_base: "https://letsboost.net"
  },
  {
    name: "linkvertise",
    regex: /^https?:\/\/(linkvertise\.(com|download)|(adf\.ly)|(link-(center|target|hub|to)|direct-link|file-link|link-target)\.net)/i,
    userscript_regex: "*://linkvertise.com/*",
    valid_url_regex: /^(https?:\/\/(?:www\.)?(linkvertise\.com|linkvertise\.net|link-to\.net)\/(?!$|search|login|profile|assets\/vendor\/|assets\/external\/thinksuggest|publisher|link-mutation|blog)(.*))$/i,
    url_base: "https://linkvertise.com"
  },
  {
    name: "loot-link",
    regex: /^https:\/\/(?:loot-link|loot-links|lootlinks|lootdest|links-loot|linksloot|lootlink)\.(?:com|co|org|net|info)\/s\?./i,
    userscript_regex: [
      "*://loot-link.com/*",
      "*://loot-link.co/*",
      "*://loot-link.org/*",
      "*://loot-link.net/*",
      "*://loot-link.info/*",
      "*://loot-links.com/*",
      "*://loot-links.co/*",
      "*://loot-links.org/*",
      "*://loot-links.net/*",
      "*://loot-links.info/*",
      "*://lootlinks.com/*",
      "*://lootlinks.co/*",
      "*://lootlinks.org/*",
      "*://lootlinks.net/*",
      "*://lootlinks.info/*",
      "*://lootdest.com/*",
      "*://lootdest.co/*",
      "*://lootdest.org/*",
      "*://lootdest.net/*",
      "*://lootdest.info/*",
      "*://links-loot.com/*",
      "*://links-loot.co/*",
      "*://links-loot.org/*",
      "*://links-loot.net/*",
      "*://links-loot.info/*",
      "*://linksloot.com/*",
      "*://linksloot.co/*",
      "*://linksloot.org/*",
      "*://linksloot.net/*",
      "*://linksloot.info/*",
      "*://lootlink.com/*",
      "*://lootlink.co/*",
      "*://lootlink.org/*",
      "*://lootlink.net/*",
      "*://lootlink.info/*"
    ],
    valid_url_regex: /^https:\/\/(?:loot-link|loot-links|lootlinks|lootdest|links-loot|linksloot|lootlink)\.(?:com|co|org|net|info)\/s\?./,
    url_base: "https://loot-link.com"
  },
  {
    name: "mboost",
    regex: /^https?:\/\/mboost\.me/i,
    userscript_regex: "*://mboost.me/*",
    valid_url_regex: /^https?:\/\/mboost\.me\/a\/[a-zA-Z0-9-_]{3}$/,
    url_base: "https://mboost.me"
  },
  {
    name: "rekonise",
    regex: /^https?:\/\/(rekonise\.com|rkns\.link)/i,
    userscript_regex: [
      "*://rekonise.com/*",
      "*://rkns.link/*"
    ],
    valid_url_regex: /^https?:\/\/(rekonise\.com|rkns\.link)\/[a-zA-Z0-9-]+(?:#[a-zA-Z0-9-_]+)?$/,
    url_base: "https://rekonise.com"
  },
  {
    name: "shortest",
    regex: /^https?:\/\/(shorte\.st|sh\.st|gestyy\.com|destyy\.com)/i,
    userscript_regex: [
      "*://shorte.st/*",
      "*://sh.st/*",
      "*://gestyy.com/*",
      "*://destyy.com/*"
    ],
    valid_url_regex: /^https?:\/\/(shorte\.st|sh\.st|gestyy\.com|destyy\.com)\/[a-zA-Z0-9\/-]+(?:\?.*)?$/,
    url_base: "https://shorte.st"
  },
  {
    name: "social-unlock",
    regex: /^https?:\/\/social-unlock\.com/i,
    userscript_regex: "*://social-unlock.com/*",
    valid_url_regex: /^https?:\/\/social-unlock\.com\/[a-zA-Z0-9]+\/?$/,
    url_base: "https://social-unlock.com"
  },
  {
    name: "socialwolvez",
    regex: /^https?:\/\/socialwolvez\.com\/app\/l\//i,
    userscript_regex: "*://socialwolvez.com/app/l/*",
    valid_url_regex: /^https?:\/\/socialwolvez\.com\/app\/l\/[a-zA-Z0-9]+\/?(?:#.*)?$/,
    url_base: "https://socialwolvez.com"
  },
  {
    name: "sub1s",
    regex: /^https?:\/\/sub1s\.com\//i,
    userscript_regex: "*://sub1s.com/*",
    valid_url_regex: /^https?:\/\/sub1s\.com\/(l\/)?[a-zA-Z0-9-_]+\/?$/,
    url_base: "https://sub1s.com"
  },
  {
    name: "sub2get",
    regex: /^https?:\/\/(www\.)?sub2get\.com/i,
    userscript_regex: "*://sub2get.com/*",
    valid_url_regex: /^https?:\/\/(www\.)?sub2get\.com\/link(\.php)?\?(l|id)=\d+\/?(?:#.*)?$/,
    url_base: "https://sub2get.com"
  },
  {
    name: "subtolink",
    regex: /^https?:\/\/(www\.)?(subtolink|subfinal)\.com/i,
    userscript_regex: "*://subtolink.com/*",
    valid_url_regex: /^https?:\/\/(www\.)?(subtolink|subfinal)\.com\/.+/,
    url_base: "https://subtolink.com"
  },
  {
    name: "sub2unlock",
    regex: /https?:\/\/sub2unlock\.com/i,
    userscript_regex: "*://sub2unlock.com/*",
    valid_url_regex: /^https?:\/\/sub2unlock\.com\/[a-zA-Z0-9-_]+\/?$/,
    url_base: "https://sub2unlock.com"
  },
  {
    name: "unlocknow",
    regex: /^https?:\/\/unlocknow\.net\/*/i,
    userscript_regex: "*://unlocknow.net/*",
    valid_url_regex: /^https?:\/\/unlocknow\.net\/.+/,
    url_base: "https://unlocknow.net"
  },
  {
    name: "v.gd",
    regex: /https?:\/\/v\.gd/i,
    userscript_regex: "*://v.gd/*",
    valid_url_regex: /^https?:\/\/v\.gd\/[a-zA-Z0-9-_]+\/?$/,
    url_base: "https://v.gd"
  }
];

export function matchLink(url: string) {
  for (const regex of regexObjects) {
    if (regex.regex.test(url)) {
      return {
        match: true,
        name: regex.name,
        base: regex.url_base,
        valid_url: regex.valid_url_regex
      };
    }
  }
  return {
    match: false
  };
}
