# -------------------------------------------------------------------------
# Component template
# -------------------------------------------------------------------------
ccomp_main_mui() {
cat <<EOF
import { Box } from "@mui/material";
import { ${CCOMP_NAME}Styles as s } from './${CCOMP_NAME}.styles';

export const ${CCOMP_NAME} = ({}: ${CCOMP_NAME}Props) => {
  return (
    <Box>
      <Box>${CCOMP_NAME}</Box>
    </Box>
  );
};

export type ${CCOMP_NAME}Props = {};
EOF
}

# -------------------------------------------------------------------------
# Style template
# -------------------------------------------------------------------------
ccomp_style_mui() {
cat <<EOF
import { asStyles } from "src/types";

export const ${CCOMP_NAME}Styles = asStyles({
  root: {},
});
EOF
}

# -------------------------------------------------------------------------
# Index template
# -------------------------------------------------------------------------
ccomp_index_mui() {
cat <<EOF
export * from "./${CCOMP_NAME}";
EOF
}

ccomp() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a component name!";
        return 1;
    fi

    CCOMP_NAME="$1"
    CCOMP_DIR_RAW=""

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
        "-a")
            CCOMP_DIR_RAW="src/components/atoms/"
            shift
            ;;
        "-m")
            CCOMP_DIR_RAW="src/components/molecules/"
            shift
            ;;
        "-o")
            CCOMP_DIR_RAW="src/components/organisms/"
            shift
            ;;
        "-p")
            CCOMP_DIR_RAW="src/pages/"
            shift
            ;;
        *)
            CCOMP_NAME="$1"
            shift
            ;;
        esac
    done

    CCOMP_DIR="${CCOMP_DIR_RAW}${CCOMP_NAME}"
 
    if [[ "${CCOMP_DIR}" == "" ]]; then
    else
        mkdir "${CCOMP_DIR}"
    fi

    CCOMP_MAIN=$(ccomp_main_mui)
    CCOMP_STYLE=$(ccomp_style_mui)
    CCOMP_INDEX=$(ccomp_index_mui)
    CCOMP_INDEX_PATH=""

    if [[ "${CCOMP_DIR}" == "" ]]; then
    else
        CCOMP_INDEX_PATH="${CCOMP_DIR}/"
    fi

    echo "${CCOMP_MAIN}" > "${CCOMP_INDEX_PATH}${CCOMP_NAME}.tsx"
    echo "${CCOMP_STYLE}" > "${CCOMP_INDEX_PATH}${CCOMP_NAME}.styles.ts"
    echo "${CCOMP_INDEX}" > "${CCOMP_INDEX_PATH}index.ts"
}