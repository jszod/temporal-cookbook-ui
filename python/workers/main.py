"""
Temporal worker main script for Temporal AI Cookbook patterns.

This worker registers all workflows and activities and connects to Temporal server.
Run with: cd python && uv run python workers/main.py
"""

import asyncio
import logging
import sys
from pathlib import Path

from temporalio.client import Client
from temporalio.worker import Worker

# Add parent directory to path so we can import our modules
sys.path.insert(0, str(Path(__file__).parent.parent))

from activities.litellm_completion import create
from workflows import (
    deep_research_workflow,
    durable_agent_workflow,
    litellm_workflow,
    retry_policy_workflow,
    structured_outputs_workflow,
    tool_calling_workflow,
)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)

logger = logging.getLogger(__name__)

# Task queue name (matches what UI uses)
TASK_QUEUE = "temporal-cookbook-examples"

# Temporal server address (default for Temporal Dev Server)
TEMPORAL_ADDRESS = "localhost:7233"

# Temporal namespace (default)
TEMPORAL_NAMESPACE = "default"


async def main():
    """Main worker function."""
    logger.info("Starting Temporal worker...")
    logger.info(f"Connecting to Temporal server at {TEMPORAL_ADDRESS}")
    logger.info(f"Using namespace: {TEMPORAL_NAMESPACE}")
    logger.info(f"Task queue: {TASK_QUEUE}")

    try:
        # Connect to Temporal server
        client = await Client.connect(
            target_host=TEMPORAL_ADDRESS,
            namespace=TEMPORAL_NAMESPACE,
        )
        logger.info("Connected to Temporal server")

        # Create worker with all workflows and activities
        worker = Worker(
            client,
            task_queue=TASK_QUEUE,
            workflows=[
                litellm_workflow,
                # Placeholder workflows (not yet implemented)
                tool_calling_workflow,
                structured_outputs_workflow,
                retry_policy_workflow,
                durable_agent_workflow,
                deep_research_workflow,
            ],
            activities=[create],
        )

        logger.info("Worker initialized successfully")
        logger.info(f"  - Task queue: {TASK_QUEUE}")
        logger.info("  - Registered workflows: litellm_workflow + 5 placeholders")
        logger.info("  - Registered activities: activities.litellm_completion.create")
        logger.info("")
        logger.info("Worker running... Press Ctrl+C to stop")

        # Run worker (this blocks until interrupted)
        await worker.run()

    except KeyboardInterrupt:
        logger.info("Worker stopped by user")
    except Exception as e:
        logger.error(f"Worker error: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())

