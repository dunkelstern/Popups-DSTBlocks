# Popups+DSTBlocks

Class extensions for some UIKit classes on iOS to support blocks instead of delegation.
For quick demonstration see the `Demo` directory.

**Attention: this needs ARC!**

To include into your project just add the `Popups+DSTBlocks` directory to your project.
Include just `Popups+DSTBlocks.h` from that directory in the classes that should need the
new functionality (or drop an import statement to your prefix header to have it available in the complete project).

## DSTBlockButton

    + (DSTBlockButton *)buttonWithTitle:(NSString *)title block:(DSTButtonPressBlock)block;

To create a DSTBlockButton just call it's class initializer you can see above. The block
may be `nil` if you only wish to dismiss the dialog with the button but take no further
action.

## UIAlertView

    - (UIAlertView *)initWithTitle:(NSString *)title
                           message:(NSString *)message
                      cancelButton:(DSTBlockButton *)cancelButton
                      otherButtons:(NSArray *)otherButtons;
                      
    - (void)addButton:(DSTBlockButton *)button;

    - (void)setWillPresentBlock:(DSTWillPresentPopupBlock)block;
    - (void)setDidPresentBlock:(DSTPopupPresentedBlock)block;

Extends `UIAlertView` to be usable with blocks.
You can even use the standard initializer you know and call `addButton:` to add another
button with a block attached and process the other button taps in your delegate if you
wish.

If the `UIAlertView` is canceled programmatically the cancel button block is executed.

# License

Standard 2 clause BSD-License, see `LICENSE`

# TODO

- UIPopover
- UIActionSheet
