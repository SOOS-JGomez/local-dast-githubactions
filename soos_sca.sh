# Required Arguments
# Note, SOOS_CLIENT_ID and SOOS_API_KEY can be set below or be defined as Environment variables.
# You can get the values for SOOS_CLIENT_ID and SOOS_API_KEY from the SOOS Application
SOOS_CLIENT_ID="9sy14f68j"
SOOS_API_KEY="MDZjZThmOTAtY2UzNS00ZGMzLWFhODEtZDQ2Y2NmZDA1MzE0"
SOURCE_CODE_PATH="/Users/jgomez/Desktop/PythonScriptProd"
SOOS_PROJECT_NAME="Python Script on Mac"

# Optional Arguments
SOOS_MODE="run_and_wait"
SOOS_ON_FAILURE="fail_the_build"
SOOS_DIRS_TO_EXCLUDE="soos,abc"
SOOS_FILES_TO_EXCLUDE=""
SOOS_ANALYSIS_RESULT_MAX_WAIT=300
SOOS_ANALYSIS_RESULT_POLLING_INTERVAL=10
SOOS_API_BASE_URL="https://api.soos.io/api/"
SOOS_LATEST_REPO="https://api.github.com/repos/soos-io/soos-ci-analysis-python/releases/latest"

# Build Specific Arguments
SOOS_COMMIT_HASH=""                # ENTER COMMIT HASH HERE IF KNOWN
SOOS_BRANCH_NAME=""                # ENTER BRANCH NAME HERE IF KNOWN
SOOS_BRANCH_URI=""                 # ENTER BRANCH URI HERE IF KNOWN
SOOS_BUILD_VERSION=""              # ENTER BUILD VERSION HERE IF KNOWN
SOOS_BUILD_URI=""                  # ENTER BUILD URI HERE IF KNOWN

# **************************** Modify Above Only ***************#
WORKING_DIR="${SOURCE_CODE_PATH}/soos"
WORKSPACE="${WORKING_DIR}/workspace"
SCRIPT_FILE_NAME="soos.py"
REQUIREMENTS_FILE_NAME="requirements.txt"

echo ""
echo "Setting Up Workspace..."
mkdir -p "${WORKSPACE}"

cd ${WORKING_DIR}

echo ""
echo "Downloading..."
curl -s $SOOS_LATEST_REPO | grep "browser_download_url" | cut -d '"' -f 4 | xargs -n 1 curl -LO
sha256sum -c soos.sha256
sha256sum -c requirements.sha256

echo ""
echo "Setting Up Environment..."
python3 -m venv ./
source bin/activate

echo ""
echo "Installing Packages..."
pip3 install -r "${WORKING_DIR}/${REQUIREMENTS_FILE_NAME}"

echo ""
echo "Running Scan..."
python3 "${WORKING_DIR}/${SCRIPT_FILE_NAME}" \
  -m="${SOOS_MODE}" \
  -dte="${SOOS_DIRS_TO_EXCLUDE}" \
  -fte="${SOOS_FILES_TO_EXCLUDE}" \
  -wd="${WORKING_DIR}" \
  -armw=${SOOS_ANALYSIS_RESULT_MAX_WAIT} \
  -arpi=${SOOS_ANALYSIS_RESULT_POLLING_INTERVAL} \
  -buri="${SOOS_API_BASE_URL}" \
  -scp="${SOURCE_CODE_PATH}" \
  -pn="${SOOS_PROJECT_NAME}" \
  -ch="${SOOS_COMMIT_HASH}" \
  -bn="${SOOS_BRANCH_NAME}" \
  -bruri="${SOOS_BRANCH_URI}" \
  -bldver="${SOOS_BUILD_VERSION}" \
  -blduri="${SOOS_BUILD_URI}" \
  -cid="${SOOS_CLIENT_ID}" \
  -akey="${SOOS_API_KEY}" \
  -v=true
