## Examples

    terraspace completion

Prints words for TAB auto-completion.

    terraspace completion
    terraspace completion hello
    terraspace completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(terraspace completion_script)

Auto-completion example usage:

    terraspace [TAB]
    terraspace hello [TAB]
    terraspace hello name [TAB]
    terraspace hello name --[TAB]
