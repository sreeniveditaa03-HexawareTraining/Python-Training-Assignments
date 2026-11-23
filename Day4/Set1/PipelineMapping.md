# Definition of Done – Build Pipeline Mapping

**Project:** Digital Wallet Application  
**Sprint:** Sprint 01 – Wallet Core Features  
**Methodology:** Scrum  
**Pipeline:** Build → Test → Review → Merge

## 1. Pipeline Mapping

The Definition of Done (DoD) defines the quality standards that each user story must satisfy before being marked as Done in Jira. The proposed CI/CD workflow supports these standards through four stages.

| Pipeline Stage | Activity | DoD Requirement | Responsible |
|---|---|---|---|
| **Build** | Compile or validate application code and resolve dependency errors. | Build completes successfully without errors. | Developer / CI |
| **Test** | Execute automated unit and integration tests, including wallet balance and refund scenarios. | Required tests pass and acceptance criteria are satisfied. | Developer / QA |
| **Review** | Create a pull request and perform peer code review. | Changes are reviewed and approved. | Reviewer |
| **Merge** | Merge approved changes into the main branch after required checks pass. | Code is integrated successfully and ready for release validation. | Developer |

## 2. Pipeline Workflow

```text
Jira Story – In Progress
          |
          v
    Code Implementation
          |
          v
       BUILD
          |
          v
        TEST
          |
          v
       REVIEW
          |
          v
        MERGE
          |
          v
  Definition of Done Met
          |
          v
    Jira Story – Done
```

## 3. Sprint Application

For **DWA-119 – Refund to Wallet**, the pipeline would validate refund eligibility, wallet balance updates, duplicate-refund prevention, and transaction recording. The story can be moved to **Done** only after the agreed acceptance criteria and Definition of Done are satisfied.

**Outcome:** The mapping establishes a consistent quality process for completing and integrating Digital Wallet sprint stories.

<img width="832" height="143" alt="image" src="https://github.com/user-attachments/assets/bef674c9-2abf-44de-be8e-146b7870c778" />
