import streamlit as st

sidebar_options = [
    'Option 1',
    'Option 2',
    'Option 3'
]

def main():
    # Page settings
    st.set_page_config(
        page_title="Switching page content using dropdown selection",
        page_icon="U+F8FF",
        layout="wide"
    )

    # Sidebar Selectbox (dropdown menu)
    selection = st.sidebar.selectbox(
        label="**Select an option**",
        placeholder="",
        index=None,
        options=sidebar_options
    )

    # Changing content based on selection (with a default message)
    if selection == sidebar_options[0]:
        # Show the content applicable for Option 1
        pass
    elif selection == sidebar_options[1]:
        # Show the content applicable for Option 2
        pass
    elif selection == sidebar_options[2]:
        # Show the content applicable for Option 3
        pass
    else:
        # Default (when no selection is made)
        st.title('Selections in Sidebar')
        st.divider()
        st.subheader("Make a selection in sidebar to continue")


if __name__ == '__main__':
    main()
