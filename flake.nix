{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker.url = "github:hyprwm/Hyprland";
    #hyprpicker.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim plugin inputs (for plugins not officially packages on nix)
    dial-nvim = {
      url = "github:monaqa/dial.nvim";
      flake = false;
    };
    neo-tree-nvim = {
      url = "github:nvim-neo-tree/neo-tree.nvim";
      flake = false;
    };
    nvim-scrollbar = {
      url = "github:petertriho/nvim-scrollbar";
      flake = false;
    };
    yankassassin-vim = {
      url = "github:svban/YankAssassin.vim";
      flake = false;
    };
    nvim-base16 = {
      url = "github:rrethy/nvim-base16";
      flake = false;
    };
    vim-enfocado = {
      url = "github:wuelnerdotexe/vim-enfocado";
      flake = false;
    };
    vim-moonfly-colors = {
      url = "github:bluz71/vim-moonfly-colors";
      flake = false;
    };
    calvera-dark-nvim = {
      url = "github:yashguptaz/calvera-dark.nvim";
      flake = false;
    };
    substrata-nvim = {
      url = "github:kvrohit/substrata.nvim";
      flake = false;
    };
    monochrome-nvim = {
      url = "github:kdheepak/monochrome.nvim";
      flake = false;
    };
    zenbones-nvim = {
      url = "github:mcchrish/zenbones.nvim";
      flake = false;
    };
    alpha-nvim = {
      url = "github:goolord/alpha-nvim";
      flake = false;
    };
    kanagawa-nvim = {
      url = "github:rebelot/kanagawa.nvim";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:lewis6991/nvim-treesitter-context";
      flake = false;
    };
	};

	outputs = inputs@{ nixpkgs, nixpkgs-unstable, nixpkgs-stable, ... }:
	
	let
		system = "x86_64-linux";
		pkgs-args = {
			inherit system;
			config = {
				allowUnfree = true;
			};
			overlays = [
				inputs.nur.overlay
				#inputs.neovim-nightly.overlay # This does compile now so disable it
                inputs.hyprpicker.overlays.default
                # TODO: Automate this
				(final: prev: {
                  auto-base16-theme = final.callPackage ./packages/auto-base16-theme {};
                  schemer2 = final.callPackage ./packages/schemer2 {};
                  haishoku = final.callPackage ./packages/haishoku {};
                  commander = final.callPackage ./packages/commander {};
                  pywal = final.callPackage ./packages/pywal {};
				})
			];
		};
		pkgs = import nixpkgs pkgs-args;
		pkgs-unstable = import nixpkgs-unstable pkgs-args;
		pkgs-stable = import nixpkgs-stable pkgs-args;

		# Extend lib with my custom lib
		lib = nixpkgs.lib.extend
			(self: super: { my = import ./lib { inherit inputs lib pkgs; }; });
	in 

	with lib.my;
	{
		nixosConfigurations =
			(mapHosts {
				inherit system;
				directory = ./hosts;
				extraModules =
					[ ./hosts/default.nix ] ++
					[ inputs.home-manager.nixosModules.home-manager ] ++
					(mapModulesRecList ./modules import);
				extraSpecialArgs = { inherit pkgs-unstable pkgs-stable; };
			});
		};
}
