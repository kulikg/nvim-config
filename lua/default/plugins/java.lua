return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

            local workspace_folder = '/tmp/nvim/' .. project_name

            local data = vim.fn.stdpath('data')

            local jdtls_home = data .. "/java/jdtls/"
            local debug_home = data .. "/java/java-debug/"
            local test_home = data .. "/java/vscode-java-test/"

            local capabilities = require('blink.cmp').get_lsp_capabilities();
            local bundles = {}

            vim.list_extend(bundles,
                vim.split(vim.fn.glob(debug_home .. 'com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', true), "\n"))

            vim.list_extend(bundles,
                vim.split(vim.fn.glob(test_home .. "server/*.jar", true), "\n"))

            local root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw', 'pom.xml' }, { upward = true })[1])

            vim.g.jdtls = {
                config = {
                    flags = {
                        debounce_text_changes = 80,
                    },
                    capabilities = capabilities,

                    init_options = {
                        bundles = bundles
                    },
                    root_dir = root_dir,

                    settings = {
                        java = {
                            eclipse = {
                                downloadSources = true,
                            },
                            signatureHelp = { enabled = true },
                            contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
                            -- Specify any completion options
                            sources = {
                                organizeImports = {
                                    starThreshold = 9999,
                                    staticStarThreshold = 9999,
                                },
                            },
                            -- How code generation should act
                            codeGeneration = {
                                toString = {
                                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                                },
                                hashCodeEquals = {
                                    useJava7Objects = true,
                                },
                                useBlocks = true,
                            },
                            configuration = {
                                runtimes = {
                                    {
                                        name = "JavaSE-21",
                                        path = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/21.0.7-tem/",
                                    },
                                    {
                                        name = "JavaSE-17",
                                        path = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/17.0.15-tem/",
                                    },

                                }
                            }
                        }
                    },

                    cmd = {
                        "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/21.0.7-tem/bin/java",
                        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                        '-Dosgi.bundles.defaultStartLevel=4',
                        '-Declipse.product=org.eclipse.jdt.ls.core.product',
                        '-Dlog.protocol=true',
                        '-Dlog.level=ERROR',
                        '-Xmx4g',
                        '--add-modules=ALL-SYSTEM',
                        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                        '-javaagent:' .. jdtls_home .. '/lombok.jar',
                        '-jar', vim.fn.glob(jdtls_home .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
                        '-configuration', jdtls_home .. '/config_mac',
                        '-data', workspace_folder,
                    },
                }
            }
            local jdtls = require 'jdtls'
            jdtls.start_or_attach(vim.g.jdtls.config)

            local wk = require 'which-key'
            wk.add {
                { "<leader>j",  group = "Java" },
                { "<leader>jt", jdtls.test_nearest_method,  desc = "test nearest method" },
                { "<leader>jT", jdtls.test_class,           desc = "test class" },
                { "<leader>ja", vim.lsp.buf.code_action,    desc = "codeAction",           mode = { "n", "v" } },
                { "<leader>jr", vim.lsp.buf.rename,         desc = "refactor rename" },
                { "<leader>jf", vim.lsp.buf.format,         desc = "format code",          mode = { "n", "v" } },
                { "<leader>jo", jdtls.organize_imports,     desc = "organize imports" },
                { "<leader>je", jdtls.extract_variable,     desc = "extract variable" },
                { "<leader>jc", jdtls.extract_constant,     desc = "extract constant" },
                { "<leader>jm", jdtls.extract_method,       desc = "extract method" },
                { "<leader>js", jdtls.super_implementation, desc = "super implementation" },
                { "<leader>jS", jdtls.jshell,               desc = "jshell with classpath" },
                { "<leader>sd", vim.lsp.buf.definition,     desc = "lsp_definitions" }
            }
        end
    }
}
