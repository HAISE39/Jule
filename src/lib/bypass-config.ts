export interface LinkConfig {
  name: string;
  regex: RegExp;
  userscript_regex: string | string[];
  valid_url_regex: RegExp;
  url_base: string;
}

export const regexObjects: LinkConfig[] = [
  {
    name: "work.ink",
    regex: /^https?:\/\/(www\.)?(work\.ink|paste\.work\.ink|outgoing\.work\.ink)/i,
    userscript_regex: ["https://*.work.ink/*", "https://work.ink/*"],
    valid_url_regex: /^https?:\/\/(www\.)?work\.ink\/.+/,
    url_base: "https://work.ink"
  },
  {
    name: "lootlabs",
    regex: /^https?:\/\/(?:(?:loot-link|loot-links|lootlinks|lootdest|links-loot|linksloot|lootlink)\.(?:com|co|org|net|info|gg)|links\.lootlabs\.gg)/i,
    userscript_regex: [
        "https://*.lootdest.org/*",
        "https://lootdest.org/*",
        "https://*.loot-link.com/*",
        "https://loot-link.com/*",
        "https://*.loot-links.com/*",
        "https://loot-links.com/*",
        "https://links.lootlabs.gg/*"
    ],
    valid_url_regex: /^https?:\/\/.+/,
    url_base: "https://loot-link.com"
  },
  {
    name: "platorelay",
    regex: /^https?:\/\/auth\.platorelay\.com/i,
    userscript_regex: "https://auth.platorelay.com/*",
    valid_url_regex: /^https?:\/\/auth\.platorelay\.com\/.+/,
    url_base: "https://auth.platorelay.com"
  },
  {
    name: "linkvertise",
    regex: /^https?:\/\/(linkvertise\.(com|download)|(adf\.ly)|(link-(center|target|hub|to)|direct-link|file-link|link-target)\.net)/i,
    userscript_regex: "https://linkvertise.com/*",
    valid_url_regex: /^(https?:\/\/(?:www\.)?(linkvertise\.com|linkvertise\.net|link-to\.net)\/(?!$|search|login|profile|assets\/vendor\/|assets\/external\/thinksuggest|publisher|link-mutation|blog)(.*))$/i,
    url_base: "https://linkvertise.com"
  },
  {
    name: "cuty",
    regex: /^https?:\/\/cuttlinks\.com/i,
    userscript_regex: "https://cuttlinks.com/*",
    valid_url_regex: /^https?:\/\/cuttlinks\.com\/.+/,
    url_base: "https://cuttlinks.com"
  },
  {
    name: "shortfly",
    regex: /^https?:\/\/(shrtslug\.biz|biovetro\.net|technons\.com|yrtourguide\.com|tournguide\.com)/i,
    userscript_regex: [
        "https://shrtslug.biz/*",
        "https://biovetro.net/*",
        "https://technons.com/*",
        "https://yrtourguide.com/*",
        "https://tournguide.com/*"
    ],
    valid_url_regex: /^https?:\/\/.+/,
    url_base: "https://shortfly.com"
  },
  {
    name: "rekonise",
    regex: /^https?:\/\/(rekonise\.com|rkns\.link)/i,
    userscript_regex: "https://rekonise.com/*",
    valid_url_regex: /^https?:\/\/(rekonise\.com|rkns\.link)\/[a-zA-Z0-9-]+(?:#[a-zA-Z0-9-_]+)?$/,
    url_base: "https://rekonise.com"
  },
  {
    name: "lockr",
    regex: /^https?:\/\/lockr\.so/i,
    userscript_regex: "https://lockr.so/*",
    valid_url_regex: /^https?:\/\/lockr\.so\/.+/,
    url_base: "https://lockr.so"
  },
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
