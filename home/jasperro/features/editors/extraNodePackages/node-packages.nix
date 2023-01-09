# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@emmetio/abbreviation-2.2.3" = {
      name = "_at_emmetio_slash_abbreviation";
      packageName = "@emmetio/abbreviation";
      version = "2.2.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/@emmetio/abbreviation/-/abbreviation-2.2.3.tgz";
        sha512 = "87pltuCPt99aL+y9xS6GPZ+Wmmyhll2WXH73gG/xpGcQ84DRnptBsI2r0BeIQ0EB/SQTOe2ANPqFqj3Rj5FOGA==";
      };
    };
    "@emmetio/css-abbreviation-2.1.4" = {
      name = "_at_emmetio_slash_css-abbreviation";
      packageName = "@emmetio/css-abbreviation";
      version = "2.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/@emmetio/css-abbreviation/-/css-abbreviation-2.1.4.tgz";
        sha512 = "qk9L60Y+uRtM5CPbB0y+QNl/1XKE09mSO+AhhSauIfr2YOx/ta3NJw2d8RtCFxgzHeRqFRr8jgyzThbu+MZ4Uw==";
      };
    };
    "@emmetio/scanner-1.0.0" = {
      name = "_at_emmetio_slash_scanner";
      packageName = "@emmetio/scanner";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@emmetio/scanner/-/scanner-1.0.0.tgz";
        sha512 = "8HqW8EVqjnCmWXVpqAOZf+EGESdkR27odcMMMGefgKXtar00SoYNSryGv//TELI4T3QFsECo78p+0lmalk/CFA==";
      };
    };
    "@rometools/cli-darwin-arm64-11.0.0" = {
      name = "_at_rometools_slash_cli-darwin-arm64";
      packageName = "@rometools/cli-darwin-arm64";
      version = "11.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rometools/cli-darwin-arm64/-/cli-darwin-arm64-11.0.0.tgz";
        sha512 = "F3vkdY+s3FLIEnAjSbyHTuIPB88cLpccimW4ecid5I7S6GzGG3iUJI4xT00JhH73K4P/qW20/9r+kH1T9Du8Xg==";
      };
    };
    "@rometools/cli-darwin-x64-11.0.0" = {
      name = "_at_rometools_slash_cli-darwin-x64";
      packageName = "@rometools/cli-darwin-x64";
      version = "11.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rometools/cli-darwin-x64/-/cli-darwin-x64-11.0.0.tgz";
        sha512 = "X6jhtS6Iml4GOzgNtnLwIp/KXXhSdqeVyfv69m/AHnIzx3gQAjPZ7BPnJLvTCbhe4SKHL+uTZYFSCJpkUUKE6w==";
      };
    };
    "@rometools/cli-linux-arm64-11.0.0" = {
      name = "_at_rometools_slash_cli-linux-arm64";
      packageName = "@rometools/cli-linux-arm64";
      version = "11.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rometools/cli-linux-arm64/-/cli-linux-arm64-11.0.0.tgz";
        sha512 = "dktTJJlTpmycBZ2TwhJBcAO8ztK8DdevdyZnFFxdYRvtmJgTjIsC2UFayf/SbKew8B8q1IhI0it+D6ihAeIpeg==";
      };
    };
    "@rometools/cli-linux-x64-11.0.0" = {
      name = "_at_rometools_slash_cli-linux-x64";
      packageName = "@rometools/cli-linux-x64";
      version = "11.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rometools/cli-linux-x64/-/cli-linux-x64-11.0.0.tgz";
        sha512 = "WVcnXPNdWGUWo0p4NU8YzuthjYR7q+b4vRcjdxtP1DlpphZmSsoC/RSE85nEqRAz8hChcKUansVzOPM8BSsuGA==";
      };
    };
    "@rometools/cli-win32-arm64-11.0.0" = {
      name = "_at_rometools_slash_cli-win32-arm64";
      packageName = "@rometools/cli-win32-arm64";
      version = "11.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rometools/cli-win32-arm64/-/cli-win32-arm64-11.0.0.tgz";
        sha512 = "tPj6RThQzS7Q45jqQll7NlTYvNcsg/BEP3LYiiazqSh9FAFnMkrV6ewUcMPKWyAfiyLs7jlz4rRvdNRUSygzfQ==";
      };
    };
    "@rometools/cli-win32-x64-11.0.0" = {
      name = "_at_rometools_slash_cli-win32-x64";
      packageName = "@rometools/cli-win32-x64";
      version = "11.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rometools/cli-win32-x64/-/cli-win32-x64-11.0.0.tgz";
        sha512 = "bmBai8WHxYjsGk1+je7ZTfCUCWq30WJI3pQM8pzTA674lfGTZ9ymJoZwTaIMSO4rL5V9mlO6uLunsBKso9VqOg==";
      };
    };
    "@types/node-17.0.45" = {
      name = "_at_types_slash_node";
      packageName = "@types/node";
      version = "17.0.45";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/node/-/node-17.0.45.tgz";
        sha512 = "w+tIMs3rq2afQdsPJlODhoUEKzFP1ayaoyl1CcnwtIlsVe7K7bA1NGm4s3PraqTLlXnbIN84zuBlxBWo1u9BLw==";
      };
    };
    "emmet-2.3.6" = {
      name = "emmet";
      packageName = "emmet";
      version = "2.3.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/emmet/-/emmet-2.3.6.tgz";
        sha512 = "pLS4PBPDdxuUAmw7Me7+TcHbykTsBKN/S9XJbUOMFQrNv9MoshzyMFK/R57JBm94/6HSL4vHnDeEmxlC82NQ4A==";
      };
    };
    "gonzales-pe-4.3.0" = {
      name = "gonzales-pe";
      packageName = "gonzales-pe";
      version = "4.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/gonzales-pe/-/gonzales-pe-4.3.0.tgz";
        sha512 = "otgSPpUmdWJ43VXyiNgEYE4luzHCL2pz4wQ0OnDluC6Eg4Ko3Vexy/SrSynglw/eR+OhkzmqFCZa/OFa/RgAOQ==";
      };
    };
    "lilconfig-2.0.6" = {
      name = "lilconfig";
      packageName = "lilconfig";
      version = "2.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/lilconfig/-/lilconfig-2.0.6.tgz";
        sha512 = "9JROoBW7pobfsx+Sq2JsASvCo6Pfo6WWoUW79HuB1BCoBXD4PLWJPqDF6fNj67pqBYTbAHkE57M1kS/+L1neOg==";
      };
    };
    "lodash.camelcase-4.3.0" = {
      name = "lodash.camelcase";
      packageName = "lodash.camelcase";
      version = "4.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash.camelcase/-/lodash.camelcase-4.3.0.tgz";
        sha512 = "TwuEnCnxbc3rAvhf/LbG7tJUDzhqXyFnv3dtzLOPgCG/hODL7WFnsbwktkD7yUV0RrreP/l1PALq/YSg6VvjlA==";
      };
    };
    "minimist-1.2.7" = {
      name = "minimist";
      packageName = "minimist";
      version = "1.2.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-1.2.7.tgz";
        sha512 = "bzfL1YUZsP41gmu/qjrEk0Q6i2ix/cVeAhbCbqH9u3zYutS1cLg00qhrD0M2MVdCcx4Sc0UpP2eBWo9rotpq6g==";
      };
    };
    "nanoid-3.3.4" = {
      name = "nanoid";
      packageName = "nanoid";
      version = "3.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/nanoid/-/nanoid-3.3.4.tgz";
        sha512 = "MqBkQh/OHTS2egovRtLk45wEyNXwF+cokD+1YPf9u5VfJiRdAiRwB2froX5Co9Rh20xs4siNPm8naNotSD6RBw==";
      };
    };
    "picocolors-0.2.1" = {
      name = "picocolors";
      packageName = "picocolors";
      version = "0.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/picocolors/-/picocolors-0.2.1.tgz";
        sha512 = "cMlDqaLEqfSaW8Z7N5Jw+lyIW869EzT73/F5lhtY9cLGoVxSXznfgfXMO0Z5K0o0Q2TkTXq+0KFsdnSe3jDViA==";
      };
    };
    "picocolors-1.0.0" = {
      name = "picocolors";
      packageName = "picocolors";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz";
        sha512 = "1fygroTLlHu66zi26VoTDv8yRgm0Fccecssto+MhsZ0D/DGW2sm8E8AjW7NU5VVTRt5GxbeZ5qBuJr+HyLYkjQ==";
      };
    };
    "postcss-7.0.39" = {
      name = "postcss";
      packageName = "postcss";
      version = "7.0.39";
      src = fetchurl {
        url = "https://registry.npmjs.org/postcss/-/postcss-7.0.39.tgz";
        sha512 = "yioayjNbHn6z1/Bywyb2Y4s3yvDAeXGOyxqD+LnVOinq6Mdmd++SW2wUNVzavyyHxd6+DxzWGIuosg6P1Rj8uA==";
      };
    };
    "postcss-8.4.21" = {
      name = "postcss";
      packageName = "postcss";
      version = "8.4.21";
      src = fetchurl {
        url = "https://registry.npmjs.org/postcss/-/postcss-8.4.21.tgz";
        sha512 = "tP7u/Sn/dVxK2NnruI4H9BG+x+Wxz6oeZ1cJ8P6G/PZY0IKk4k/63TDsQf2kQq3+qoJeLm2kIBUNlZe3zgb4Zg==";
      };
    };
    "postcss-less-4.0.1" = {
      name = "postcss-less";
      packageName = "postcss-less";
      version = "4.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/postcss-less/-/postcss-less-4.0.1.tgz";
        sha512 = "C92S4sHlbDpefJ2QQJjrucCcypq3+KZPstjfuvgOCNnGx0tF9h8hXgAlOIATGAxMXZXaF+nVp+/Mi8pCAWdSmw==";
      };
    };
    "postcss-sass-0.4.4" = {
      name = "postcss-sass";
      packageName = "postcss-sass";
      version = "0.4.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/postcss-sass/-/postcss-sass-0.4.4.tgz";
        sha512 = "BYxnVYx4mQooOhr+zer0qWbSPYnarAy8ZT7hAQtbxtgVf8gy+LSLT/hHGe35h14/pZDTw1DsxdbrwxBN++H+fg==";
      };
    };
    "postcss-scss-3.0.5" = {
      name = "postcss-scss";
      packageName = "postcss-scss";
      version = "3.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/postcss-scss/-/postcss-scss-3.0.5.tgz";
        sha512 = "3e0qYk87eczfzg5P73ZVuuxEGCBfatRhPze6KrSaIbEKVtmnFI1RYp1Fv+AyZi+w8kcNRSPeNX6ap4b65zEkiA==";
      };
    };
    "source-map-0.6.1" = {
      name = "source-map";
      packageName = "source-map";
      version = "0.6.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz";
        sha512 = "UjgapumWlbMhkBgzT7Ykc5YXUT46F0iKu8SGXq0bcwP5dz/h0Plj6enJqjz1Zbq2l5WaqYnrVbwWOWMyF3F47g==";
      };
    };
    "source-map-js-1.0.2" = {
      name = "source-map-js";
      packageName = "source-map-js";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/source-map-js/-/source-map-js-1.0.2.tgz";
        sha512 = "R0XvVJ9WusLiqTCEiGCmICCMplcCkIwwR11mOSD9CR5u+IXYdiseeEuXCVAjS54zqwkLcPNnmU4OeJ6tUrWhDw==";
      };
    };
    "typescript-4.9.4" = {
      name = "typescript";
      packageName = "typescript";
      version = "4.9.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/typescript/-/typescript-4.9.4.tgz";
        sha512 = "Uz+dTXYzxXXbsFpM86Wh3dKCxrQqUcVMxwU54orwlJjOpO3ao8L7j5lH+dWfTwgCwIuM9GQ2kvVotzYJMXTBZg==";
      };
    };
    "vscode-jsonrpc-6.0.0" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-6.0.0.tgz";
        sha512 = "wnJA4BnEjOSyFMvjZdpiOwhSq9uDoK8e/kpRJDTaMYzwlkrhG1fwDIZI94CLsLzlCK5cIbMMtFlJlfR57Lavmg==";
      };
    };
    "vscode-jsonrpc-8.0.2" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "8.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-8.0.2.tgz";
        sha512 = "RY7HwI/ydoC1Wwg4gJ3y6LpU9FJRZAUnTYMXthqhFXXu77ErDd/xkREpGuk4MyYkk4a+XDWAMqe0S3KkelYQEQ==";
      };
    };
    "vscode-languageserver-7.0.0" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "7.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-7.0.0.tgz";
        sha512 = "60HTx5ID+fLRcgdHfmz0LDZAXYEV68fzwG0JWwEPBode9NuMYTIxuYXPg4ngO8i8+Ou0lM7y6GzaYWbiDL0drw==";
      };
    };
    "vscode-languageserver-protocol-3.16.0" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.16.0.tgz";
        sha512 = "sdeUoAawceQdgIfTI+sdcwkiK2KU+2cbEYA0agzM2uqaUy2UpnnGHtWTHVEtS0ES4zHU0eMFRGN+oQgDxlD66A==";
      };
    };
    "vscode-languageserver-protocol-3.17.2" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.17.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.2.tgz";
        sha512 = "8kYisQ3z/SQ2kyjlNeQxbkkTNmVFoQCqkmGrzLH6A9ecPlgTbp3wDTnUNqaUxYr4vlAcloxx8zwy7G5WdguYNg==";
      };
    };
    "vscode-languageserver-textdocument-1.0.8" = {
      name = "vscode-languageserver-textdocument";
      packageName = "vscode-languageserver-textdocument";
      version = "1.0.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.8.tgz";
        sha512 = "1bonkGqQs5/fxGT5UchTgjGVnfysL0O8v1AYMBjqTbWQTFn721zaPGDYFkOKtfDgFiSgXM3KwaG3FMGfW4Ed9Q==";
      };
    };
    "vscode-languageserver-types-3.16.0" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0.tgz";
        sha512 = "k8luDIWJWyenLc5ToFQQMaSrqCHiLwyKPHKPQZ5zz21vM+vIVUSvsRpcbiECH4WR88K2XZqc4ScRcZ7nk/jbeA==";
      };
    };
    "vscode-languageserver-types-3.17.2" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.17.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.2.tgz";
        sha512 = "zHhCWatviizPIq9B7Vh9uvrH6x3sK8itC84HkamnBWoDFJtzBf7SWlpLCZUit72b3os45h6RWQNC9xHRDF8dRA==";
      };
    };
    "vscode-uri-3.0.7" = {
      name = "vscode-uri";
      packageName = "vscode-uri";
      version = "3.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.7.tgz";
        sha512 = "eOpPHogvorZRobNqJGhapa0JdwaxpjVvyBp0QIUMRMSf8ZAlqOdEquKuRmw9Qwu0qXtJIWqFtMkmvJjUZmMjVA==";
      };
    };
  };
in
{
  rome = nodeEnv.buildNodePackage {
    name = "rome";
    packageName = "rome";
    version = "11.0.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/rome/-/rome-11.0.0.tgz";
      sha512 = "rRo6JOwpMLc3OkeTDRXkrmrDqnxDvZ75GS4f0jLDBNmRgDXWbu0F8eVnJoRn+VbK2AE7vWvhVOMBjnWowcopkQ==";
    };
    dependencies = [
      sources."@rometools/cli-darwin-arm64-11.0.0"
      sources."@rometools/cli-darwin-x64-11.0.0"
      sources."@rometools/cli-linux-arm64-11.0.0"
      sources."@rometools/cli-linux-x64-11.0.0"
      sources."@rometools/cli-win32-arm64-11.0.0"
      sources."@rometools/cli-win32-x64-11.0.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Rome is a toolchain for the web: formatter, linter and more";
      homepage = "https://rome.tools";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
  cssmodules-language-server = nodeEnv.buildNodePackage {
    name = "cssmodules-language-server";
    packageName = "cssmodules-language-server";
    version = "1.2.1";
    src = fetchurl {
      url = "https://registry.npmjs.org/cssmodules-language-server/-/cssmodules-language-server-1.2.1.tgz";
      sha512 = "mQI7d3NxucZX5sLq+hSb7xiyKxPzJiVisdH9QBqVaBzKSXjzg5PBn1GGkHRlFA5zDTkM/8PORnXUiG5JqO9YTg==";
    };
    dependencies = [
      sources."gonzales-pe-4.3.0"
      sources."lilconfig-2.0.6"
      sources."lodash.camelcase-4.3.0"
      sources."minimist-1.2.7"
      sources."nanoid-3.3.4"
      sources."picocolors-1.0.0"
      sources."postcss-8.4.21"
      sources."postcss-less-4.0.1"
      (sources."postcss-sass-0.4.4" // {
        dependencies = [
          sources."picocolors-0.2.1"
          sources."postcss-7.0.39"
        ];
      })
      sources."postcss-scss-3.0.5"
      sources."source-map-0.6.1"
      sources."source-map-js-1.0.2"
      sources."vscode-jsonrpc-6.0.0"
      (sources."vscode-languageserver-7.0.0" // {
        dependencies = [
          sources."vscode-languageserver-protocol-3.16.0"
        ];
      })
      (sources."vscode-languageserver-protocol-3.17.2" // {
        dependencies = [
          sources."vscode-jsonrpc-8.0.2"
          sources."vscode-languageserver-types-3.17.2"
        ];
      })
      sources."vscode-languageserver-textdocument-1.0.8"
      sources."vscode-languageserver-types-3.16.0"
      sources."vscode-uri-3.0.7"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "language server for cssmodules";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
  emmet-ls = nodeEnv.buildNodePackage {
    name = "emmet-ls";
    packageName = "emmet-ls";
    version = "0.3.1";
    src = fetchurl {
      url = "https://registry.npmjs.org/emmet-ls/-/emmet-ls-0.3.1.tgz";
      sha512 = "SbNxxpLHnkaT/lA8CpOnnu1fH+VMzEAniAoyqQV+CGVJ9BYwHbaDlOPRckoJFK/6czWCQqDWax1Gk5Pa+HrNmA==";
    };
    dependencies = [
      sources."@emmetio/abbreviation-2.2.3"
      sources."@emmetio/css-abbreviation-2.1.4"
      sources."@emmetio/scanner-1.0.0"
      sources."@types/node-17.0.45"
      sources."emmet-2.3.6"
      sources."typescript-4.9.4"
      sources."vscode-jsonrpc-6.0.0"
      sources."vscode-languageserver-7.0.0"
      sources."vscode-languageserver-protocol-3.16.0"
      sources."vscode-languageserver-textdocument-1.0.8"
      sources."vscode-languageserver-types-3.16.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "emmet support by LSP";
      homepage = "https://github.com/aca/emmet-ls#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
