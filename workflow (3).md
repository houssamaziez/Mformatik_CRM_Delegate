```mermaid
stateDiagram-v2
    NEW --> STARTED: Responsible Only
    STARTED --> RESPONSIBLE_CLOSED: Task Completed
    OWNER_RESPOND --> RESPONSIBLE_CLOSED: Owner Approved
    RESPONSIBLE_RESPOND --> RESPONSIBLE_CLOSED: Responsible Approved
    RESPONSIBLE_CLOSED --> CLOSED: Final Approval
    NEW --> CANCELED: Owner Only
