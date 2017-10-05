		/* Sticky nvigation */

		var sticky = {
			$sticky      : $( '.sticky' ),
			offsets      : [],
			targets      : [],
			stickyTop    : null,

			set : function() {
				var self = this;

				self.offsets = [];
				self.targets = [];

				// Get current top position of sticky element
				self.stickyTop = self.$sticky.css( 'position', 'relative' ).offset().top;

				// Cache all targets and their top positions
				self.$sticky.find( 'a' ).map(function () {
					var $el		= $( this ),
						href	= $el.data('target') || $el.attr( 'href' ),
						$href	= /^#./.test(href) && $( href );

					return $href && $href.length && $href.is( ':visible' ) ? [ [ Math.floor( $href.offset().top - parseInt( $href.css('margin-top') ) ), href ] ] : null;
				})
				.sort(function (a, b) { return a[0] - b[0] })
				.each(function () {
					self.offsets.push( this[ 0 ] );
					self.targets.push( this[ 1 ] );
				});

			},

			update : function() {
				var self = this;

				var windowTop       = Math.floor( $(window).scrollTop() );
				var $stickyLinks    = self.$sticky.find( 'a' ).removeClass( 'active' );
				var stickyPosition  = 'fixed';
				var currentIndex    = 0;

				// Toggle fixed position depending on visibility
				if ( $(window).width() < 800 || self.stickyTop > windowTop ) {
					stickyPosition = 'relative';

				} else {

					for ( var i = self.offsets.length; i--; ) {
						if ( windowTop >= self.offsets[ i ] && ( self.offsets[ i + 1 ] === undefined || windowTop <= self.offsets[ i + 1 ]) ) {
							currentIndex = i;

							break;
						}
					}

				}

				self.$sticky.css( 'position', stickyPosition );

				$stickyLinks.eq( currentIndex ).addClass( 'active' );
			},

			init : function() {
				var self = this;

				$(window).on('resize', function() {

					self.set();

					self.update();

				});

				$(window).on('scroll', function() {

					self.update();

				});

				self.set();

				self.update();

			}
		}

		sticky.init();