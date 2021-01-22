# Top 10% iOS Developer App Case Study

![](https://github.com/rombiddle/Top10iOSDeveloper/workflows/CI-macOS/badge.svg)

## BDD Specs

### Story: user requests to see the requirements

### Narrative #1
```
As an online user,
I want the app to automatically load the latest requirements
So I can always see the latest requirements to be a top 10% iOS dev
```

#### Scenarios (Acceptance criteria)
```
Given the user has connectivity
When the user requests to see the requirements
Then the app should display the latest requirements from remote
    And replace the cache with the new requirements
```

### Narrative #2
```
As an offline user,
I want the app to automatically load the latest saved requirements
So I can always see the requirements
```

#### Scenarios (Acceptance criteria)
```
Given the user does not have connectivity
When the user requests to see the requirements
Then the app should display the latest saved requirements

Given the user does not have connectivity And the cache is empty
When the user requests to see the requirements
Then the app should display an error message
```

### Story: user requests to validate a requirement

### Narrative #1
```
As an online user,
I want the app to save my requirements done
So I can follow my progress 
```

#### Scenarios (Acceptance criteria)
```
Given the user have connectivity
When the user validate a requirement
Then the app should validate the requirement remotely And save in the cache
```

### Narrative #2
```
As an offline user,
I want the app to save validated requirements locally
So I can follow my progress
```

#### Scenarios (Acceptance criteria)
```
Given the user does not have connectivity
When the user validate a requirement
Then the app should save locally the requirement 

Given the user does not have connectivity
And the cache is full
When the user requests to save a validated requirement
Then the app should display an error message
```

## Use Cases

### User requests to see the requirements

#### Data:
- URL

#### Primary course (happy path):
1. Execute “Load Requirements” command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates requirements from valid data.
5. System delivers requirements.

#### Invalid data - error course (sad path):
1. System delivers error.

#### No connectivity - error course (sad path):
1. System delivers error.

### User requests fallback to see the requirements (Cache)

#### Data:
- Max age

#### Primary course (happy path):
1. Execute “Retrieve Requirement items” command with above data.
2. System fetches requirement data from cache.
3. System creates requirement items  from cached data.
4. System delivers requirements.

#### No cache course (sad path):
1. System delivers no requirement items.

### Save requirements

#### Data:
- Requirements items

#### Primary course (happy path):
1. Execute “Save Requirement items” command with above data.
2. System validates requirement items.
3. System timestamps the new cache.
4. System replaces the cache with new data.
5. System delivers a success message..

### Validate a requirement

#### Data:
- Requirements items

#### Primary course (happy path):
1. Execute “Validate Requirement items” command with above data.
2. System validates requirement items remotely and locally.
3. System shows validated requirements.

#### No connectivity - error course (sad path):
1. System delivers error.

## Model Specs

### Requirement Category
| Property | Type                 |
|----------|----------------------|
| `id`     | `UUID`               |
| `name`   | `String`             |
| `groups` | `[RequirementGroup]` |

### Requirement Group
| Property | Type                |
|----------|---------------------|
| `id`     | `UUID`              |
| `name`   | `String`            |
| `items`  | `[RequirementItem]` |

### Requirement Item
| Property | Type              |
|----------|-------------------|
| `id`     | `UUID`            |
| `name`   | `String`          |
| `type`   | `RequirementType` |

### Payload contract

```
GET /requirements

200 RESPONSE

{
    "categories": [
        {
            "id": "a UUID",
            "name": "a name",
            "groups": [
                {
                    "id": "a UUID",
                    "name": "a name",
                    "items": [
                        {
                            "id": "a UUID",
                            "name": "a name",
                            "type": 0
                        }
                        ...
                    ]
                }
                ...
            ]
        }
        ...
    ]
}
```

---

## UML Diagram

![](UMLDiagram.jpg)

