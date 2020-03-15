set -eu

export VCAP_SERVICES=$(cat Tests/Resources/TestVcapServices.json)
export IBM_CREDENTIALS_FILE=$(pwd)/ibm-credentials.env
swift test
