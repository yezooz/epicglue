export GO15VENDOREXPERIMENT=1

make deps    # Download required dependencies
make gen     # Generate code
make build   # Build the binary